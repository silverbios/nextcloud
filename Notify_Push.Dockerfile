FROM alpine:3.19 AS downloader

ARG NOTIFY_PUSH_VERSION
ARG TARGETARCH

RUN case "$TARGETARCH" in \
      amd64)   ARCH="x86_64" ;; \
      arm64)   ARCH="aarch64" ;; \
      *) echo "Unsupported arch: $TARGETARCH" && exit 1 ;; \
    esac && \
    apk add --no-cache curl && \
    curl -L "https://github.com/nextcloud/notify_push/releases/download/${NOTIFY_PUSH_VERSION}/notify_push-${ARCH}-unknown-linux-musl" -o /notify_push && \
    chmod +x /notify_push

FROM scratch
COPY --from=downloader /notify_push /notify_push

EXPOSE 7867
ENTRYPOINT ["/notify_push"]
