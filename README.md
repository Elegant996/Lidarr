# Lidarr
Lidarr is a music collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new tracks from your favorite artists and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.

Docker
-----------------------------------------------
This repo will periodically check Lidarr for updates and build a container image from scratch using an Alpine base layout:

For `master` branch releases use:
```
docker pull ghcr.io/elegant996/lidarr:2.5.3.4341
docker pull ghcr.io/elegant996/lidarr:master
```

For `develop` branch pre-releases use:
```
docker pull ghcr.io/elegant996/lidarr:2.5.2.4316
docker pull ghcr.io/elegant996/lidarr:develop
```