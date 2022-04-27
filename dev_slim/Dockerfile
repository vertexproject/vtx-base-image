FROM vtx:py310

RUN set -ex \
    && pip install synapse \
    && apt remove -y --allow-remove-essential e2fsprogs \
    && apt autoremove -y \
    && dpkg --remove --force all perl-base
