# Usage

Clone the project

```shell script
git clone --depth 1 https://github.com/cetver/local-docker-skeleton -- project_name
```

Change the current directory

```shell script
cd project_name
```

Remove the `.git` and `.gitignore`

```shell script
fdfind --hidden .git . --exec rm --verbose --recursive --force {}
```

Delete unnecessary images in the `.docker` directory (mysql, nginx, php, postgresql, redis)

Replace variables in the `docker-compose.yml` file

```shell script
sed --regexp-extended --in-place \
    --expression "s@\\$\{PROJECT_NAME\}@project_name@" \
    --expression "s@\\$\{PWD\}@$(pwd)/.docker@" \
    --expression "s@\\$\{SYSTEM_LOCALE\}@en_GB.UTF-8@" \
    --expression "s@\\$\{SOURCES_LIST_COUNTRY_CODE\}@md@" \
    .docker/docker-compose.yml
```

Review
- The files marked as `*** DESCRIPTION ***` in [Structure](#Structure) 
- The `docker-compose.yml` file 

Copy scripts from `setup/common` to `<image>/setup/common`

```shell script
.docker/setup/copy-common-scripts
```
  
Builds, (re)creates, starts, and attaches to containers for a service.

```shell script
docker-compose --file .docker/docker-compose.yml up --detach --build 
```

Change volumes permissions / ownership

```shell script
# socket directories
fdfind --type directory run .docker --exec sudo chmod --verbose --recursive 777 {}
# configuration directories
fdfind --type directory etc .docker --exec sudo chown --verbose --recursive "$(whoami)" {}
```

# Reload configuration inside the container
- Nginx: `nginx -s reload` 
- PHP-FPM: `sudo kill -USR2 1`
- PostgreSQL: `kill -SIGHUP 1 | psql -U postgres -c 'SELECT pg_reload_conf();'`
- Others require a container restart

# Structure

**Description marked as `*** DESCRIPTION ***` must be viewed or edited before executing `docker-compose`**

```
.docker
├── docker-compose.yml
├── mysql                                       = MySQL image
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── setup                                   = Initial configuration directory
│   │   └── configure                           = *** CREATE /etc/mysql/conf.d/docker-mysqld.cnf ***
│   └── volumes                                 = Volumes directory
│       ├── etc                                 = /etc/mysql
│       │   └── .gitignore
│       ├── lib                                 = /var/lib/mysql
│       │   └── .gitignore
│       └── run                                 = /var/run/mysqld
│           └── .gitignore
├── nginx                                       = Nginx image
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── setup                                   = Initial configuration directory
│   │   ├── configure                           = Copy template/* into /etc/nginx.
│   │   ├── create_debian_rules_cflags_patch.py = Create the patch file based on "nginx-source/debian/rules" 
|   |   |                                         by changing CFLAGS (configure flags) 
|   |   |                                         for "nginx" and "nginx-dbg" packages
│   │   ├── install                             = *** CONFIGURE AND INSTALL WITH REQUIRED FLAGS / MODULES ***
│   │   └── template                            = *** INITIAL CONFIG FILES TO BE COPIED INTO /etc/nginx *** 
│   │       ├── includes
│   │       │   ├── cache-files.conf
│   │       │   ├── cache-headers.conf
│   │       │   ├── log-off.conf
│   │       │   ├── php.conf
│   │       │   ├── security.conf
│   │       │   └── security-headers.conf
│   │       ├── modules-available
│   │       │   ├── http-brotli.conf
│   │       │   └── http-echo.conf
│   │       ├── modules-conf.d
│   │       │   ├── brotli.conf
│   │       │   └── gzip.conf
│   │       ├── modules-enabled
│   │       │   └── .gitignore
│   │       ├── nginx.conf
│   │       ├── sites-available
│   │       │   └── skeleton.conf
│   │       └── sites-enabled
│   │           └── .gitignore
│   └── volumes                                 = Volumes directory
│       ├── etc                                 = /etc/nginx
│       │   └── .gitignore
│       └── run                                 = Socket directory
│           └── php                             = /var/run/php
│               └── .gitignore
├── php                                         = PHP image
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── entrypoint
│   ├── setup                                   = Initial configuration directory
│   │   ├── configure-fpm                       = *** CONFIGURE THE "PHP-FPM" CONFIGURATION FILES ***
│   │   ├── configure-ini                       = *** CONFIGURE THE "PHP CLI/FPM" MAIN CONFIGURATION FILES ***
│   │   ├── install-composer                    = Install composer
│   │   ├── install-ext                         = *** CONFIGURE AND INSTALL PHP EXTENSIONS ***
│   │   └── install-nodejs                      = Install NodeJS/YARN
│   └── volumes                                 = Volumes directory
│       ├── etc                                 = /usr/local/etc
│       │   └── .gitignore
│       └── run                                 = Socket directory
│           ├── mysql                           = /var/run/mysql
│           │   └── .gitignore
│           ├── php                             = /var/run/php
│           │   └── .gitignore
│           ├── postgresql                      = /var/run/postgresql
│           │   └── .gitignore
│           └── redis                           = /var/run/redis
│               └── .gitignore
├── postgresql                                  = PostgreSQL image
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── setup                                   = Initial configuration directory
│   │   └── create-extensions.sql               = *** CREATE EXTENSIONS FROM pg_available_extensions ***
│   │   └── tuning.sql                          = *** UPDATE POSTGRES CONFIGURATION PARAMETERS ***
│   └── volumes                                 = Volumes directory
│       ├── lib                                 = /var/lib/postgresql/data
│       │   └── .gitignore
│       └── run                                 = /var/run/postgresql
│           └── .gitignore
├── redis                                       = Redis image
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── setup                                   = Initial configuration directory
│   │   └── configure                           = *** UPDATE /etc/redis/redis.conf ***
│   └── volumes                                 = Volumes directory
│       ├── etc                                 = /etc/redis/
│       │   └── .gitignore
│       ├── lib                                 = /data
│       │   └── .gitignore
│       └── run                                 = /var/run/redis
│           └── .gitignore
└── setup                                       = Contains required scripts for containers building
    ├── common
    │   ├── add-system-user
    │   ├── ansi-format
    │   ├── apt-get-install
    │   ├── clear-fs
    │   ├── configure-bash
    │   ├── create-socket-dir
    │   ├── get-code-name
    │   ├── rewrite-sources-list
    │   └── update-locale
    └── copy-common-scripts                     = Copy scripts from [setup/common] to [<image>/setup/common]
```

# Demo project: skeleton

Update the `/etc/hosts` file

```shell script
echo "
##
# Skeleton
##

127.0.0.1    skeleton.loc
" | sudo tee --append /etc/hosts
``` 

Steps from [Usage](#Usage), except Review*

Create the project

```shell script
docker-compose --file .docker/docker-compose.yml exec skeleton-php /bin/bash --login
skeleton@php7_4-debian:/var/www/html$ composer create-project symfony/website-skeleton
skeleton@php7_4-debian:/var/www/html$ fdfind --hidden --max-depth 1 . website-skeleton --exec mv --verbose {} .
skeleton@php7_4-debian:/var/www/html$ rmdir --verbose website-skeleton
skeleton@php7_4-debian:/var/www/html$ composer require symfony/webpack-encore-bundle
skeleton@php7_4-debian:/var/www/html$ yarn install
skeleton@php7_4-debian:/var/www/html$ yarn add bootstrap
skeleton@php7_4-debian:/var/www/html$ echo "
##
# Docker
##

/.docker

##
# Composer
##

/.composer

##
# YARN
##

/.yarn
.yarnrc
" | tee --append .gitignore
skeleton@php7_4-debian:/var/www/html$ sed --in-place --regexp-extended "s@;?opcache\.preload=.*@opcache\.preload=/var/www/html/var/cache/dev/App_KernelDevDebugContainer.preload.php@" "${PHP_INI_DIR}/php-cli.ini"
skeleton@php7_4-debian:/var/www/html$ sed --in-place --regexp-extended "s@;?opcache\.preload_user=.*@opcache\.preload_user=$(whoami)@" "${PHP_INI_DIR}/php-cli.ini"
skeleton@php7_4-debian:/var/www/html$ sed --in-place --regexp-extended "s@;?opcache\.preload=.*@opcache\.preload=/var/www/html/var/cache/dev/App_KernelDevDebugContainer.preload.php@" "${PHP_INI_DIR}/php-fpm-fcgi.ini"
skeleton@php7_4-debian:/var/www/html$ sed --in-place --regexp-extended "s@;?opcache\.preload_user=.*@opcache\.preload_user=$(ps -o user= -p $(pidof -s php-fpm))@" "${PHP_INI_DIR}/php-fpm-fcgi.ini"
skeleton@php7_4-debian:/var/www/html$ sudo kill -USR2 1
```

Source code

- `webpack.config.js`
```
//.addEntry('page2', './assets/js/page2.js')
+ .addStyleEntry('bootstrap', './node_modules/bootstrap/dist/css/bootstrap.min.css')
```

- `config/routes.yaml`
```yaml
index:
    path: /
    controller: App\Controller\DefaultController::indexAction
```

- `config/packages/cache.yaml`
```yaml
framework:
    cache:
        app: cache.adapter.redis
        default_redis_provider: redis:/var/run/redis/redis.sock
```

- `config/packages/doctrine.yaml`
```yaml
doctrine:
    dbal:
        default_connection: default
        connections:
            default:
                url: 'sqlite:///%kernel.project_dir%/var/app.db'
            mysql:
                url: 'mysql://root:root@localhost/skeleton'
                driver: 'pdo_mysql'
                server_version: '8.0'
                charset: 'utf8mb4'
            pgsql:
                driver: 'pdo_pgsql'
                user: 'postgres'
                password: 'root'
                host: '/var/run/postgresql'
                port: '5432'
                dbname: 'skeleton'
                charset: 'UTF8'
    orm:
        auto_generate_proxy_classes: true
        naming_strategy: doctrine.orm.naming_strategy.underscore_number_aware
        auto_mapping: true
        mappings:
            App:
                is_bundle: false
                type: annotation
                dir: '%kernel.project_dir%/src/Entity'
                prefix: 'App\Entity'
                alias: App
```

- `src/Controller/DefaultController.php`
```php
<?php declare(strict_types=1);

namespace App\Controller;

use Psr\Cache\CacheItemPoolInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

/**
 * The "DefaultController" class
 */
class DefaultController extends AbstractController
{
    private CacheItemPoolInterface $cache;

    public function __construct(CacheItemPoolInterface $cache)
    {
        $this->cache = $cache;
    }

    public function indexAction()
    {
        $stats = [];
        /** @var \Doctrine\DBAL\Connection[] $connections */
        $connections = $this->getDoctrine()->getConnections();
        foreach ($connections as $connection) {
            $platformName = $connection->getDatabasePlatform()->getName();
            $query = ($platformName === 'sqlite') ? 'SELECT sqlite_version()' : 'SELECT version()';
            $version = $connection->executeQuery($query)->fetchColumn();
            $stats[] = [
                'platform' => $platformName,
                'version' => $version,
                'icon' => $this->getPlatformIcon($platformName)
            ];
        }

        return $this->render('default/index.html.twig', compact('stats'));
    }

    public function getPlatformIcon($platform)
    {
        $item = $this->cache->getItem($platform);
        if (!$item->isHit()) {
            switch ($platform) {
                default:
                    $color = '#000000';
                    break;
                case 'sqlite':
                    $color = '#800000';
                    break;
                case 'mysql':
                    $color = '#008000';
                    break;
                case 'postgresql':
                    $color = '#000080';
                    break;
            }

            $gmagic = new \Gmagick();
            $gmagic->newimage(34, 34, $color, 'png');
            $image = base64_encode($gmagic->getimageblob());

            $item->set($image);
            $this->cache->save($item);
        }

        return $item->get();
    }
}
```

- `templates/base.html.twig`
```twig
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>{% block title %}Welcome!{% endblock %}</title>
    {% block stylesheets %}
        {{ encore_entry_link_tags('bootstrap') }}
    {% endblock %}
</head>
<body class="bg-light">
<div class="container">
    <div class="mb-5"></div>
    {% block body %}{% endblock %}
</div>

{% block javascripts %}
    {{ encore_entry_script_tags('app') }}
{% endblock %}
</body>
</html>
```

- `templates/default/index.html.twig`

```twig
{% extends 'base.html.twig' %}
{% block body %}
    <main role="main" class="container">
        <div class="my-3 p-3 bg-white rounded shadow-sm">
            <h6 class="border-bottom border-gray pb-2 mb-0">Statistics</h6>
            {% for stat in stats %}
                <div class="media text-muted pt-3">
                    <img class="mr-2 rounded" src="data:image/png;base64,{{ stat.icon }}" alt="">
                    <p class="media-body pb-3 mb-0 small lh-125 border-bottom border-gray">
                        <strong class="d-block text-gray-dark">{{ stat.platform }}</strong>
                        {{ stat.version }}
                    </p>
                </div>
            {% endfor %}
        </div>
    </main>    
{% endblock %}
```

Create sqlite db and compile assets 

```shell script
skeleton@php7_4-debian:/var/www/html$ bin/console doctrine:database:create
skeleton@php7_4-debian:/var/www/html$ yarn encore dev
```

Open [http://skeleton.loc/](http://skeleton.loc/)