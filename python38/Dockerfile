FROM ubuntu:20.04

MAINTAINER vEpiphyte <epiphyte@vertex.link>

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED 1

COPY get-pip-22.0.4.py get-pip.py
COPY pandoc.deb.sha256 pandoc.deb.sha256
COPY requirements requirements
# apt get clean / update / upgrade / install required packages / clean up
# setup locales
# install python packages
#  Since we are using --no-deps if a package has a missing dependency here,
#  it will fail during testing.
# cleanup
RUN set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install --no-install-recommends -y locales curl tini python3.8-dev python3.8-full \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 \
    && cat get-pip.py | python \
    && curl -L -o pandoc-amd64.deb https://github.com/jgm/pandoc/releases/download/2.14.0.1/pandoc-2.14.0.1-1-amd64.deb \
    && sha256sum --check pandoc.deb.sha256 \
    && dpkg -i pandoc-amd64.deb \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    && mv requirements/requirements_38.txt requirements/requirements_specific.txt \
    && pip install --no-deps -r requirements/requirements.txt \
    && groupadd -g 9999 synuser \
    && useradd -m -u 9999 -g synuser synuser \
    && rm -rf requirements \
    && rm pandoc.deb.sha256 \
    && rm pandoc-amd64.deb \
    && rm get-pip.py \
    && apt remove -y curl \
    && apt autoremove -y \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
