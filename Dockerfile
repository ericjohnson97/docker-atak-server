# Dockerfile
# syntax=docker/dockerfile:1.6

ARG TEMURIN_VERSION=17
FROM eclipse-temurin:${TEMURIN_VERSION}-jammy AS base
ENV LC_ALL=C.UTF-8
RUN apt-get update && apt-get install -y \
      unzip tini curl jq postgresql-client python3-lxml \
      netcat net-tools vim pwgen zip openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
         -o /usr/bin/wait-for-it.sh \
    && chmod +x /usr/bin/wait-for-it.sh

# gomplate (pvarki templates use it)
COPY --from=hairyhenderson/gomplate:stable /gomplate /bin/gomplate

SHELL ["/bin/bash","-lc"]

# >>> Provide the TAK zip from your build context
ARG TAK_ZIP=takgov_assets/takserver-docker-5.5-RELEASE-45.zip
ARG TAK_ZIP_SHA256=""   # optional integrity check
COPY ${TAK_ZIP} /tmp/takserver.zip
RUN if [[ -n "${TAK_ZIP_SHA256}" ]]; then \
      echo "${TAK_ZIP_SHA256}  /tmp/takserver.zip" | sha256sum -c - ; \
    fi

# Unpack official distro (it contains /tak under takserver-docker-*)
RUN cd /tmp \
 && unzip -q takserver.zip \
 && rm takserver.zip \
 && DISTDIR=$(echo takserver-docker-*) \
 && mv "${DISTDIR}/tak" /opt/tak

# Bring over pvarki scripts/templates/entrypoint (from your repo)
COPY docker/entrypoint.sh /entrypoint.sh
COPY scripts   /opt/scripts
COPY templates /opt/templates

# Final stage
ENTRYPOINT ["/usr/bin/tini","--","/entrypoint.sh"]
