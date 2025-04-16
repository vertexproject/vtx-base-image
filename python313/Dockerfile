FROM python:3.13.3-slim-bookworm

LABEL maintainer="vEpiphyte <epiphyte@vertex.link>"

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED=1

COPY get-pip-25.0.1.py get-pip.py
COPY pandoc.deb.sha256 pandoc.deb.sha256
COPY requirements requirements
COPY python313/rmlist.txt rmlist.txt

# Install dependencies, Python 3.13, and setup environment
RUN set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y locales curl tini nano gnupg2 python3-setuptools build-essential \
    # Install pip
    && python get-pip.py --no-cache-dir --break-system-packages \
    # Install pandoc
    && curl -L -o pandoc-amd64.deb https://github.com/jgm/pandoc/releases/download/3.1.9/pandoc-3.1.9-1-amd64.deb \
    && sha256sum --check pandoc.deb.sha256 \
    && dpkg -i pandoc-amd64.deb \
    # Configure locales
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    # Install our packages
    && mv requirements/requirements_313.txt requirements/requirements_specific.txt \
    && pip install --no-cache-dir --no-deps -r requirements/requirements.txt --break-system-packages \
    # Setup synuser
    && groupadd -g 999 synuser \
    && useradd -r --home-dir=/home/synuser -u 999 -g synuser --shell /bin/bash synuser \
    && mkdir -p /home/synuser \
    && chown synuser:synuser /home/synuser \
    # Cleanup
    && rm -rf requirements \
    && apt-get remove -y --purge curl build-essential gnupg2 \
    && apt-get remove -y --allow-remove-essential --purge e2fsprogs \
    && apt-get autoremove -y --purge \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* \
    && rm pandoc.deb.sha256 \
    && rm pandoc-amd64.deb \
    && rm get-pip.py \
    && while read path; do if [ -e $path ]; then echo "Removing ${path}" && rm -rf $path; else echo "! Path not present: ${path}"; exit 1; fi done < rmlist.txt \
    && rm rmlist.txt

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
