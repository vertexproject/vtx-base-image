FROM debian:bookworm-slim

MAINTAINER vEpiphyte <epiphyte@vertex.link>

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED 1

COPY get-pip-23.0.1.py get-pip.py
COPY pandoc.deb.sha256 pandoc.deb.sha256
COPY requirements requirements
COPY python311/rmlist.txt rmlist.txt
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
    && apt-get install -y locales curl tini nano python3.11 python3.11-distutils \
    && apt-get install -y build-essential python3.11-dev \
    # Setup python /pip
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 \
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
    && mv requirements/requirements_311.txt requirements/requirements_specific.txt \
    && pip install --no-cache-dir --no-deps -r requirements/requirements.txt --break-system-packages \
    # Setup synuser
    && groupadd -g 999 synuser \
    && useradd -r --home-dir=/home/synuser -u 999 -g synuser --shell /bin/bash synuser \
    && mkdir -p /home/synuser \
    && chown synuser:synuser /home/synuser \
    # Cleanup
    && rm -rf requirements \
    && apt-get remove -y curl build-essential python3.11-dev \
    && apt-get remove -y --allow-remove-essential e2fsprogs \
    && apt-get autoremove -y \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/* \
    && rm pandoc.deb.sha256 \
    && rm pandoc-amd64.deb \
    && rm get-pip.py \
    && while read path; do if [ -e $path ]; then echo "Removing ${path}" && rm -rf $path; else echo "! Path not present: ${path}"; exit 1; fi done < rmlist.txt \
    && rm rmlist.txt

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
