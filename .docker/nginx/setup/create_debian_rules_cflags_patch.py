#!/usr/bin/env python3

import sys
import getopt
import os
import re


def usage():
    script_name = os.path.basename(sys.argv[0])
    help = f'''
Usage: {script_name} [OPTION]
Create the patch file based on "nginx-source/debian/rules" by changing CFLAGS (configure flags) for "nginx" and "nginx-dbg" packages

Options:
    --debian-rules-file    Path to the "nginx-source/debian/rules" file
    --nginx-cflags         CFLAGS (configure flags) for the "nginx" package
    --nginx-dbg-cflags     CFLAGS (configure flags) for the "nginx-dbg" package
    --help                 Display this message
    '''

    print(help)


def ansi_format(string, color):
    fg_colors = {
        'black': 30,
        'red': 31,
        'green': 32,
        'yellow': 33,
        'blue': 34,
        'purple': 35,
        'cyan': 36,
        'grey': 37
    }
    fg_color = str(fg_colors[color])

    print(f'\033[0m\033[0{fg_color}m{string}\033[0m')


def main(args):
    debian_rules_file = ''
    nginx_cflags = ''
    nginx_dbg_cflags = ''

    try:
        short_options = ''
        long_options = [
            'help', 'debian-rules-file=', 'nginx-cflags=', 'nginx-dbg-cflags='
        ]
        (options, arguments) = getopt.getopt(args, short_options, long_options)
    except getopt.GetoptError:
        usage()
        sys.exit(1)

    for (option, value) in options:
        if option == '--help':
            usage()
            sys.exit()
        elif option == '--debian-rules-file':
            debian_rules_file = value
        elif option == '--nginx-cflags':
            nginx_cflags = value
        elif option == '--nginx-dbg-cflags':
            nginx_dbg_cflags = value

    script_name = sys.argv[0]
    script_args = ' '.join(args)
    command = f'{script_name} {script_args}'
    ansi_format(command, 'yellow')

    debian_rules_basedir = os.path.dirname(debian_rules_file)
    with open(debian_rules_file, 'r') as handle:
        content = handle.read()

        pattern = r'(cd \$\(BUILDDIR_nginx\) && \\)(.*?)(touch \$@)'
        replacement = fr'\1\n{nginx_cflags}\n\t\3'
        new_content = re.sub(pattern, replacement, content, 0, re.DOTALL)

        pattern = r'(cd \$\(BUILDDIR_nginx_debug\) && \\)(.*?)(touch \$@)'
        replacement = fr'\1\n{nginx_dbg_cflags}\n\t\3'
        new_content = re.sub(pattern, replacement, new_content, 0, re.DOTALL)

        new_debian_rules_file = os.path.join(debian_rules_basedir,
                                             'rules-cflags.new')
        with open(new_debian_rules_file, 'w') as new_debian_rules_handle:
            new_debian_rules_handle.write(new_content)

        patch_file = os.path.join(debian_rules_basedir, 'rules-cflags.patch')
        patch_command = f'diff --unified {debian_rules_file} {new_debian_rules_file} | tee {patch_file}'
        os.system(patch_command)

        output = f'''
The patch file: {patch_file}
To apply the patch: patch --backup {debian_rules_file} {patch_file}
        '''
        ansi_format(output, 'green')


if __name__ == '__main__':
    main(sys.argv[1:])
