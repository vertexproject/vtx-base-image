FROM python:3.13.3-slim-bookworm

LABEL maintainer="vEpiphyte <epiphyte@vertex.link>"

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED=1

COPY requirements requirements
COPY python313/rmlist.txt rmlist.txt

# Install dependencies, and setup environment
RUN set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y locales curl tini nano pandoc build-essential \
    # Configure locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    # Install our packages \
    && mv requirements/requirements_313.txt requirements/requirements_specific.txt \
    && pip install -U pip setuptools \
    && pip install --no-cache-dir --no-deps -r requirements/requirements.txt \
    # Setup synuser \
    && groupadd -g 999 synuser \
    && useradd -r --home-dir=/home/synuser -u 999 -g synuser --shell /bin/bash synuser \
    && mkdir -p /home/synuser \
    && chown synuser:synuser /home/synuser \
    # Cleanup \
    && apt-get remove -y --purge curl build-essential \
    && apt-get remove -y --allow-remove-essential --purge e2fsprogs \
    && apt-get autoremove -y --purge \
    && apt-get purge && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && while read path; do \
      if [ -e "${path}" ]; then \
        echo "Removing ${path}" && rm -rf "${path}"; \
      else \
        echo "! Path not present: ${path}"; exit 1; \
      fi done < rmlist.txt \
    # Note, these files still can be discovered from image layers \
    && rm -rf requirements rmlist.txt

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
