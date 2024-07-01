FROM alpine:3.20 as stage

ARG PACKAGE
ARG VERSION

RUN apk add --no-cache \
    curl \
    xz
RUN mkdir -p /opt/Lidarr
RUN curl -o /tmp/lidarr.tar.gz -sL "${PACKAGE}"
RUN tar xzf /tmp/lidarr.tar.gz -C /opt/Lidarr --strip-components=1
RUN rm -rf /opt/Lidarr/Lidarr.Update /tmp/*

FROM alpine:3.20 as mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    busybox \
    chromaprint \
    gettext-libs \
    icu-libs \
    libcurl \
    libmediainfo \
    sqlite-libs \
    tzdata
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
COPY --from=stage /opt/Lidarr /opt/Lidarr/

EXPOSE 8686 6868
VOLUME [ "/data" ]
ENV HOME /data
WORKDIR $HOME
CMD ["/opt/Lidarr/Lidarr", "-nobrowser", "-data=/data"]

LABEL org.opencontainers.image.description="Looks and smells like Sonarr but made for music."
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.source="https://github.com/Lidarr/Lidarr"
LABEL org.opencontainers.image.title="Lidarr"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.url="https://lidarr.audio/"