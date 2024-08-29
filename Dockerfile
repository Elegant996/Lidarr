FROM scratch AS source

ADD ./lidarr.tar.gz /

FROM alpine:3.20 AS build-sysroot

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
RUN rm -f /sysroot/opt/Lidarr/Lidarr.Update

FROM scratch
COPY --from=build-sysroot /sysroot/ /

EXPOSE 8686 6868
VOLUME [ "/data" ]
ENV HOME=/data
WORKDIR $HOME
ENTRYPOINT []
CMD ["/opt/Lidarr/Lidarr", "-nobrowser", "-data=/data"]

ARG VERSION

LABEL org.opencontainers.image.description="Looks and smells like Sonarr but made for music."
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.source="https://github.com/Lidarr/Lidarr"
LABEL org.opencontainers.image.title="Lidarr"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.url="https://lidarr.audio/"