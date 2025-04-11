FROM debian:bookworm-slim

LABEL maintainer="vEpiphyte <epiphyte@vertex.link>"

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED=1

COPY pandoc.deb.sha256 pandoc.deb.sha256
COPY requirements requirements
COPY python313/rmlist.txt rmlist.txt

# Install dependencies, Python 3.13, and setup environment
RUN set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y locales curl tini nano gnupg2 \
    # Add trixie repository for Python 3.13
    && echo "deb http://deb.debian.org/debian/ trixie main contrib non-free" > /etc/apt/sources.list.d/trixie.list \
    && echo "Package: *" > /etc/apt/preferences.d/trixie.pref \
    && echo "Pin: release n=trixie" >> /etc/apt/preferences.d/trixie.pref \
    && echo "Pin-Priority: 50" >> /etc/apt/preferences.d/trixie.pref \
    && apt-get update \
    && apt-get install -y build-essential \
    && apt-get install -t trixie -y python3.13 python3.13-dev python3-setuptools python3-pip \
    # Alias python / python3 to python3.13
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.13 1 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 \
    # Upgrade pip using pip
    && python3.13 -m pip install --upgrade pip --break-system-packages \
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
    && mv requirements/requirements_311.txt requirements/requirements_specific.txt \
    && pip install --no-cache-dir --no-deps -r requirements/requirements.txt --break-system-packages \
    # Setup synuser
    && groupadd -g 999 synuser \
    && useradd -r --home-dir=/home/synuser -u 999 -g synuser --shell /bin/bash synuser \
    && mkdir -p /home/synuser \
    && chown synuser:synuser /home/synuser \
    # Cleanup
    && rm -rf requirements \
    && apt-get remove -y --purge curl build-essential python3.13-dev gnupg2 \
    && apt-get remove -y --allow-remove-essential --purge e2fsprogs \
    && apt-get autoremove -y --purge \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/apt/sources.list.d/trixie.list \
    && rm -rf /etc/apt/preferences.d/trixie.pref \
    && rm pandoc.deb.sha256 \
    && rm pandoc-amd64.deb \
    && while read path; do if [ -e $path ]; then echo "Removing ${path}" && rm -rf $path; else echo "! Path not present: ${path}"; exit 1; fi done < rmlist.txt \
    && rm rmlist.txt

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
