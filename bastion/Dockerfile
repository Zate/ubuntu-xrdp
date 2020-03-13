FROM ubuntu:18.04 as base
LABEL maintainer="Zate Berg"

# Versions
ARG XRDP_VER="0.9.10"
ENV XRDP_VER=${XRDP_VER}
ARG XORGXRDP_VER="0.2.10"
ENV XORGXRDP_VER=${XORGXRDP_VER}

FROM base as builder

# Install packages

ENV DEBIAN_FRONTEND noninteractive
RUN sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list
ENV BUILD_DEPS="git autoconf pkg-config libssl-dev libpam0g-dev \
    libx11-dev libxfixes-dev libxrandr-dev nasm xsltproc flex \
    bison libxml2-dev dpkg-dev libcap-dev libfuse-dev libpulse-dev libtool \
    xserver-xorg-dev wget ssl-cert"
RUN apt update && apt -y full-upgrade && apt install -y sudo xrdp apt-utils software-properties-common $BUILD_DEPS

RUN apt build-dep -y xrdp

WORKDIR /tmp
RUN apt build-dep -y xorgxrdp
RUN wget https://github.com/neutrinolabs/xorgxrdp/releases/download/v"${XORGXRDP_VER}"/xorgxrdp-"${XORGXRDP_VER}".tar.gz
RUN tar -zxf xorgxrdp-"$XORGXRDP_VER".tar.gz
COPY xorgxrdp /tmp/xorgxrdp-"${XORGXRDP_VER}"/
WORKDIR /tmp/xorgxrdp-"${XORGXRDP_VER}"
RUN dpkg-buildpackage -rfakeroot -uc -b
RUN dpkg -i /tmp/xorgxrdp_"${XORGXRDP_VER}"-1_amd64.deb

FROM base
ARG ADDITIONAL_PACKAGES="xrdp"
ENV ADDITIONAL_PACKAGES=${ADDITIONAL_PACKAGES}

ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt -y full-upgrade && apt install -y \
  ca-certificates \
  less \
  locales \
  openssh-server \
  ssl-cert \
  sudo \
  supervisor \
  uuid-runtime \
  vim \
  wget \
  xauth \
  xautolock \
  xfce4 \
  xfce4-clipman-plugin \
  xfce4-cpugraph-plugin \
  xfce4-netload-plugin \
  xfce4-screenshooter \
  xfce4-taskmanager \
  xfce4-terminal \
  xfce4-xkb-plugin \
  xprintidle \
  $ADDITIONAL_PACKAGES \
  && \
  rm -rf /var/cache/apt /var/lib/apt/lists
  
COPY --from=builder /tmp/xorgxrdp_${XORGXRDP_VER}-1_amd64.deb /tmp/

RUN dpkg -i /tmp/xorgxrdp_"${XORGXRDP_VER}"-1_amd64.deb && \
    rm -rf /tmp/xorgxrdp_"${XORGXRDP_VER}"-1_amd64.deb

COPY bin /usr/bin
COPY etc /etc
COPY autostart /etc/xdg/autostart


RUN mkdir /var/run/dbus && \
  cp /etc/X11/xrdp/xorg.conf /etc/X11 && \
  sed -i "s/console/anybody/g" /etc/X11/Xwrapper.config && \
  sed -i "s/xrdp\/xorg/xorg/g" /etc/xrdp/sesman.ini && \
  locale-gen en_US.UTF-8 && \
  echo "xfce4-session" > /etc/skel/.Xclients && \
  cp -r /etc/ssh /ssh_orig && \
  rm -rf /etc/ssh/* && \
  rm -rf /etc/xrdp/rsakeys.ini /etc/xrdp/*.pem


VOLUME ["/etc/ssh","/home"]
EXPOSE 3389 9001
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["supervisord"]
