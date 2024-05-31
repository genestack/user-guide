VERSION 0.8

docs:
    FROM python:3.12.3
    DO github.com/genestack/earthly-libs+PYTHON_PREPARE

    # Build
    COPY --dir jupyter_notebooks scripts shiny-server source Makefile .
    RUN \
        --secret NEXUS_USER \
        --secret NEXUS_PASSWORD \
            pypi-login.sh && \
            python3 -m pip install --no-cache-dir -r source/requirements.txt && \
            make markdown && \
            pypi-clean.sh

    # Push
    WORKDIR build/markdown
    ARG --required RAW_REGISTRY_SNAPSHOTS
    ARG --required USER_GUIDE_VERSION
    RUN \
        --push \
        --secret NEXUS_USER \
        --secret NEXUS_PASSWORD \
            export DOC_ARCHIVE=user-guide-${USER_GUIDE_VERSION}.tar.gz && \
            mkdir -p doc-odm-user-guide/doc-odm-user-guide && \
            cp -r ../../source/doc-odm-user-guide/images doc-odm-user-guide/doc-odm-user-guide/. && \
            tar cf ${DOC_ARCHIVE} * && \
            curl -v --fail --user ${NEXUS_USER}:${NEXUS_PASSWORD} \
                -H 'Content-Type: application/gzip' \
                 --upload-file ${DOC_ARCHIVE} \
                 ${RAW_REGISTRY_SNAPSHOTS}/docs/user-guide/${DOC_ARCHIVE}

main:
    BUILD +docs
