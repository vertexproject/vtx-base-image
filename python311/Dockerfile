FROM python:3.11-bookworm AS base

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED 1

COPY python311/rmlist.txt rmlist.txt
COPY requirements requirements
# apt get clean / update / upgrade / install required packages / clean up
# install python packages
#  Since we are using --no-deps if a package has a missing dependency here,
#  it will fail during testing.
RUN --mount=type=cache,target=/root/.cache \
    set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install --no-install-recommends --no-install-suggests -y build-essential \
    # Install our packages \
    && mv requirements/requirements_311.txt requirements/requirements_specific.txt \
    && pip install --no-deps -r requirements/requirements.txt \
    # Cleanup \
    && pip uninstall -y wheel setuptools pip \
    && while read -r path; do \
      if [ -e "${path}" ]; then \
        echo "Removing ${path}" && rm -rf "${path}"; \
      else \
        echo "! Path not present: ${path}"; exit 1; \
      fi \
    done < rmlist.txt

FROM python:3.11-slim-bookworm

MAINTAINER vEpiphyte <epiphyte@vertex.link>

ENV DEBIAN_FRONTEND="noninteractive"
ENV PYTHONUNBUFFERED 1

COPY --from=base  /usr/local/lib/python3.11/site-packages/ \
    /usr/local/lib/python3.11/site-packages/

# apt get clean / update / upgrade / install required packages / clean up
# setup locales
# cleanup
RUN --mount=type=cache,target=/root/.cache \
    set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get install --no-install-recommends --no-install-suggests -y \
      locales tini pandoc nano \
    # Configure locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    # Setup synuser \
    && groupadd -g 999 synuser \
    && useradd -r --home-dir=/home/synuser -u 999 -g synuser --shell /bin/bash synuser \
    && mkdir -p /home/synuser \
    && chown synuser:synuser /home/synuser \
    # Slimmed down version \
    && apt-get remove -y --allow-remove-essential e2fsprogs \
    && apt-get autoremove -y \
    && apt-get clean && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

ENV LANG="en_US.UTF-8" LANGUAGE="en_US.UTF-8" LC_ALL="en_US.UTF-8"
