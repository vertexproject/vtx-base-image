# FROM debian:bookworm-slim
FROM alpine:3.15

MAINTAINER vEpiphyte <epiphyte@vertex.link>

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED 1

COPY get-pip-21.3.1.py get-pip-21.3.1.py
COPY pandoc.deb.sha256 pandoc.deb.sha256
COPY requirements requirements
# apt get clean / update / upgrade / install required packages / clean up
# setup locales
# install python packages
#  Since we are using --no-deps if a package has a missing dependency here,
#  it will fail during testing.
# cleanup
RUN set -ex \
    && apk update \
    && apk upgrade \
    && apk add curl python3-dev patch musl-dev libffi-dev tini openssl-dev \
#    && apk add curl python3-dev py3-pip patch musl-dev libffi-dev tini openssl-dev \
    && apk add gcc g++ rust cargo \
#    # Install pandoc
#    && curl -L -o pandoc-amd64.deb https://github.com/jgm/pandoc/releases/download/2.14.0.1/pandoc-2.14.0.1-1-amd64.deb \
#    && sha256sum --check pandoc.deb.sha256 \
#    && dpkg -i pandoc-amd64.deb \
#    # Configure locales
#    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
#    && locale-gen en_US.UTF-8 \
#    && dpkg-reconfigure locales \
#    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    # Install our packages
    && cat get-pip-21.3.1.py | python3 \
    && python3 -m pip install -U pip wheel \
    && mv requirements/requirements_310.txt requirements/requirements_specific.txt \
    && pip install --prefer-binary --no-deps -r requirements/requirements.txt \
    # Cleanup
    && rm -rf requirements \
    && apk del gcc g++ rust cargo \
    && rm pandoc.deb.sha256 \
    && rm get-pip-21.3.1.py

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
