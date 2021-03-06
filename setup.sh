#!/bin/bash

# tldr
# gossm
# vimrc
# historysync

SHELLCHECK_VERSION="v0.8.0"
GOSSM_VERSION="1.4.6"
SHFMT_VERSION="3.4.3"
TRIVY_VERSION="0.27.1"
TERRAFORM_VERSION="1.2.2"
GHCLI_VERSION="2.12.1"

export DEBIAN_FRONTEND=noninteractive

function install_packages {

    apt-get update
    apt-get -y install --no-install-recommends \
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
        pwgen \
        software-properties-common \
        redis-tools \
        dos2unix \
        bash-completion \
        lsb-release \
        ca-certificates \
        iputils-ping \
        python3-distutils
}

function install_shellcheck {

    curl -sL \
        "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" \
        -o /tmp/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz
    tar -xf /tmp/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz -C /tmp/
    sudo cp /tmp/shellcheck-${SHELLCHECK_VERSION}/shellcheck /usr/local/bin/
    sudo chmod +x /usr/local/bin/shellcheck
    #sudo rm -rf /tmp/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz /tmp/shellcheck-${SHELLCHECK_VERSION}
}

function install_aws_cli {
    curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -q /tmp/awscliv2.zip -d /tmp/awscliv2
    sudo /tmp/awscliv2/aws/install
}

function install_aws_sam {
    curl -sL \
        https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip \
        -o /tmp/aws-sam-cli-linux-x86_64.zip
    unzip -q /tmp/aws-sam-cli-linux-x86_64.zip -d /tmp/sam-installation
    sudo /tmp/sam-installation/install
}

function install_session_manager {
    curl -sL "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
        -o "/tmp/session-manager-plugin.deb"
    sudo dpkg -i "/tmp/session-manager-plugin.deb"
}

function install_gossm {

    curl -sL \
        "https://github.com/gjbae1212/gossm/releases/download/v${GOSSM_VERSION}/gossm_${GOSSM_VERSION}_Linux_x86_64.tar.gz" \
        -o /tmp/gossm_${GOSSM_VERSION}_Linux_x86_64.tar.gz
    tar -xf /tmp/gossm_${GOSSM_VERSION}_Linux_x86_64.tar.gz -C /tmp/
    sudo mv /tmp/gossm /usr/local/bin/
    sudo chmod +x /usr/local/bin/gossm
    #sudo rm -rf /tmp/tmp/gossm_${GOSSM_VERSION}_Linux_x86_64.tar.gz
}

function install_trivy {

    curl -sL https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.deb -o /tmp/trivy_${TRIVY_VERSION}_Linux-64bit.deb
    dpkg -i /tmp/trivy_${TRIVY_VERSION}_Linux-64bit.deb

}

function install_shfmt {

    sudo curl -sL \
        "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64" \
        -o /usr/local/bin/shfmt
    sudo chmod +x /usr/local/bin/shfmt
}

function install_terraform {

    curl -sL \
        "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
        -o /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo unzip -q /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/
    sudo chmod +x /usr/local/bin/terraform
    # terraform -install-autocomplete # already in bashrc
}

function install_ghcli {
    sudo curl -sL https://github.com/cli/cli/releases/download/v${GHCLI_VERSION}/gh_${GHCLI_VERSION}_linux_amd64.deb \
        -o /tmp/gh_${GHCLI_VERSION}_linux_amd64.deb
    dpkg -i /tmp/gh_${GHCLI_VERSION}_linux_amd64.deb
}

# function install_bashhub {
#     curl -OL https://raw.githubusercontent.com/yggdrion/bashhub-client/main/install-bashhub.sh && bash install-bashhub.sh non-interactive
# }

install_packages
install_shfmt
install_terraform
install_aws_cli
install_shellcheck
install_aws_sam
install_gossm
install_trivy
install_ghcli
install_session_manager
#install_bashhub
pip install cfn-lint

rm -rf /tmp/*
apt-get autoremove -y
apt-get clean -y
rm -rf /var/lib/apt/lists/* /tmp/library-scripts/
