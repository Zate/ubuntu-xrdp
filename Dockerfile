FROM ubuntu:18.04 as base
LABEL maintainer="Zate Berg"

ARG XRDP_VER="0.9.12"
ENV XRDP_VER=${XRDP_VER}
ARG XORGXRDP_VER="0.2.12"
ENV XORGXRDP_VER=${XORGXRDP_VER}

ENV DEBIAN_FRONTEND noninteractive
ENV BUILD_DEPS="git autoconf pkg-config libssl-dev libpam0g-dev \
    libx11-dev libxfixes-dev libxrandr-dev nasm xsltproc flex \
    bison libxml2-dev dpkg-dev libcap-dev libfuse-dev libpulse-dev libtool \
    xserver-xorg-dev wget ssl-cert"
RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list && \
    apt update && apt -y full-upgrade && apt install -y sudo apt-utils software-properties-common $BUILD_DEPS