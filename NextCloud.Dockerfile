# === Use shared base image across all stages ===
FROM nextcloud:apache AS base

FROM base AS builder
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc make autoconf libsmbclient-dev libgmp-dev \
    && docker-php-source extract \
    && pecl install smbclient \
    && docker-php-source delete

RUN mkdir -p /exts && \
    cp "$(php -r 'echo ini_get("extension_dir");')/smbclient.so" /exts/ && \
    echo "extension=smbclient.so" > /exts/smbclient.ini

FROM base AS final
RUN apt-get update && apt-get install -y --no-install-recommends \
    iproute2 fuse procps smbclient libgmp-dev supervisor && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /exts /tmp/exts
RUN EXT_DIR="/usr/local/lib/php/extensions/$(php -i | grep '^extension_dir' | awk '{print $3}' | xargs basename)" && \
    cp /tmp/exts/*.so "$EXT_DIR" && \
    cp /tmp/exts/*.ini /usr/local/etc/php/conf.d/

RUN mkdir -p /var/log/supervisord /var/run/supervisord && \
    sed -i 's/CustomLog/#CustomLog/g' /etc/apache2/sites-available/000-default.conf && \
    sed -i 's/CustomLog/#CustomLog/g' /etc/apache2/conf-enabled/other-vhosts-access-log.conf

COPY supervisord.conf /
ENV NEXTCLOUD_UPDATE=1

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
