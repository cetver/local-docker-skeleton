ARG POSTGRES_VERSION=12
FROM postgres:${POSTGRES_VERSION}

ARG SOURCES_LIST_COUNTRY_CODE=md

ARG SYSTEM_LOCALE=en_GB.UTF-8

ENV DEBIAN_FRONTEND=noninteractive \
    SETUP_DIR=/tmp/setup

COPY setup ${SETUP_DIR}

RUN set -e; \
    unset LANG; \
    "${SETUP_DIR}/common/rewrite-sources-list" --country-code "${SOURCES_LIST_COUNTRY_CODE}"; \
    apt-get update; \
    apt-get --yes upgrade; \
    "${SETUP_DIR}/common/apt-get-install" nano curl ca-certificates fd-find ripgrep bash-completion procps locales; \
    "${SETUP_DIR}/common/clear-fs"; \
    \
    "${SETUP_DIR}/common/update-locale" --locale "${SYSTEM_LOCALE}"; \
    "${SETUP_DIR}/common/configure-bash"

RUN set -e; \
    fdfind --extension sql . "${SETUP_DIR}" --exec cp --verbose {} /docker-entrypoint-initdb.d; \
    rm --verbose --recursive --force "$SETUP_DIR"
