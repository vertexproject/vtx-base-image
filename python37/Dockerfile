FROM ubuntu:20.04

MAINTAINER vEpiphyte <epiphyte@vertex.link>

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED 1

COPY get-pip-21.3.1.py get-pip-21.3.1.py
COPY requirements.txt requirements.txt
COPY pandoc.deb.sha256 pandoc.deb.sha256
# apt get clean / update / upgrade / install required packages / clean up
# setup locales
# Setup crontab from https://github.com/renskiy/cron-docker-image/blob/master/debian/Dockerfile
# install python packages
# install cron
# making logging pipe
# make pam_loginuid.so optional for cron
# see https://github.com/docker/docker/issues/5663#issuecomment-42550548
RUN set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y locales curl tini software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt-get install -y python3.7-full python3.7-dev \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 \
    && curl -L -o pandoc-amd64.deb https://github.com/jgm/pandoc/releases/download/2.14.0.1/pandoc-2.14.0.1-1-amd64.deb \
    && apt remove -y curl software-properties-common \
    && apt autoremove -y \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* \
    && cat get-pip-21.3.1.py | python \
    && sha256sum --check pandoc.deb.sha256 \
    && dpkg -i pandoc-amd64.deb \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    && pip install -r requirements.txt \
    && rm requirements.txt \
    && rm pandoc.deb.sha256 \
    && rm get-pip-21.3.1.py

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
