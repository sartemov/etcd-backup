FROM alpine:3.8

COPY files/main.sh  /opt/main.sh

RUN apk add --no-cache python3 py3-pip ca-certificates && \
    pip3 install s3cmd && \
    mkdir -p /opt/source && \
    chmod 755 /opt/main.sh

WORKDIR /
CMD ["/opt/main.sh"]
