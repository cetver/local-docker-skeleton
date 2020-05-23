ARG REDIS_VERSION=6
FROM redis:${REDIS_VERSION}

ARG SOURCES_LIST_COUNTRY_CODE=md

ARG SYSTEM_LOCALE=en_GB.UTF-8

ENV DEBIAN_FRONTEND=noninteractive \
    SETUP_DIR=/tmp/setup \
    SOCKET_DIRS=redis \
    REDIS_CONFIG=/etc/redis/redis.conf

COPY setup ${SETUP_DIR}

RUN set -e; \
    "${SETUP_DIR}/common/rewrite-sources-list" --country-code "${SOURCES_LIST_COUNTRY_CODE}"; \
    apt-get update; \
    apt-get --yes upgrade; \
    "${SETUP_DIR}/common/apt-get-install" nano curl ca-certificates fd-find ripgrep bash-completion procps locales; \
    "${SETUP_DIR}/common/clear-fs"; \
    \
    "${SETUP_DIR}/common/update-locale" --locale "${SYSTEM_LOCALE}"; \
    "${SETUP_DIR}/common/configure-bash"; \
    "${SETUP_DIR}/common/create-socket-dir" --directories "${SOCKET_DIRS}"

RUN set -e; \
    "${SETUP_DIR}/configure" --version "${REDIS_VERSION}" --config-file "${REDIS_CONFIG}"; \
    rm --verbose --recursive --force "$SETUP_DIR"

# Container must be run with the '--privileged' option, otherwise you will get errors
# sysctl: setting key "net.core.somaxconn": Read-only file system
# sysctl: setting key "vm.overcommit_memory": Read-only file system
# sh: 1: cannot create /sys/kernel/mm/transparent_hugepage/enabled: Read-only file system
CMD ["sh", "-c", "\
# WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn \
# is set to the lower value of 128. \
# 511 - \${REDIS_CONFIG} - tcp-backlog \
sysctl --write net.core.somaxconn=511; \
\
# WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. \
# To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf \
# and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect. \
sysctl --write vm.overcommit_memory=1; \
\
# WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. \
# This will create latency and memory usage issues with Redis. \
# To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, \
# and add it to your /etc/rc.local in order to retain the setting after a reboot. \
# Redis must be restarted after THP is disabled. \
echo never > /sys/kernel/mm/transparent_hugepage/enabled; \
\
redis-server ${REDIS_CONFIG}; \
"]
