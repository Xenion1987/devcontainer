FROM mcr.microsoft.com/vscode/devcontainers/base:bullseye

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"
# [Option] Enable non-root Docker access in container
ARG ENABLE_NONROOT_DOCKER="true"
# [Option] Use the OSS Moby Engine instead of the licensed Docker Engine
ARG USE_MOBY="true"
# [Option] Engine/CLI Version
ARG DOCKER_VERSION="latest"

# ARG NODE_VERSION="16"
# ENV NVM_DIR=/usr/local/share/nvm
# ENV NVM_SYMLINK_CURRENT=true \
#     PATH=${NVM_DIR}/current/bin:${PATH}

ENV DOCKER_BUILDKIT=1

ARG USERNAME=automatic
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY library-scripts/*.sh /tmp/library-scripts/

RUN apt-get update \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${USERNAME}" "${USE_MOBY}" "${DOCKER_VERSION}" \
    # && if [ "${NODE_VERSION}" != "none" ]; then bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}"; fi \
    && apt-get autoremove -y && apt-get clean -y

# see: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/go.md
# ENV GOROOT=/usr/local/go \
#   GOPATH=/go
# ENV PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
# RUN apt-get update && bash /tmp/library-scripts/go-debian.sh "latest" "${GOROOT}" "${GOPATH}" && apt-get clean -y

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    netcat \
    vim \
    htop \
    zip unzip \
    git \
    curl \
    wget \
    jq \
    jo \
    xz-utils \
    file \
    gnupg \ 
    software-properties-common \
    redis-tools \
    dos2unix \
    bash-completion \
    lsb-release \
    ca-certificates \
    python3-pip \
    iputils-ping \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

COPY pre-setup.sh /tmp/
RUN /bin/bash /tmp/pre-setup.sh


VOLUME [ "/var/lib/docker" ]

ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

