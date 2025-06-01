FROM scratch AS source

ADD ./lidarr.tar.gz /

FROM alpine:3.22 AS build-sysroot

# Prepare sysroot
RUN mkdir -p /sysroot/etc/apk && cp -r /etc/apk/* /sysroot/etc/apk/

# Fetch runtime dependencies
RUN apk add --no-cache --initdb -p /sysroot \
    alpine-baselayout \
    busybox \
    chromaprint \
    gettext-libs \
    icu-libs \
    libcurl \
    libmediainfo \
    sqlite-libs \
    tzdata
RUN rm -rf /sysroot/etc/apk /sysroot/lib/apk /sysroot/var/cache

# Install Lidarr to new system root
RUN mkdir -p /sysroot/opt/Lidarr
COPY --from=source /Lidarr /sysroot/opt/Lidarr
RUN rm -rf /sysroot/opt/Lidarr/Lidarr.Update

# Install entrypoint
COPY --chmod=755 ./entrypoint.sh /sysroot/entrypoint.sh

# Build image
FROM scratch
COPY --from=build-sysroot /sysroot/ /

EXPOSE 8686 6868
VOLUME ["/data"]
ENV HOME=/data
WORKDIR $HOME
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/Lidarr/Lidarr", "-nobrowser", "-data=/data"]