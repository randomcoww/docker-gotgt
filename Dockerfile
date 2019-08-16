FROM golang:alpine as BUILD

WORKDIR /go/src/github.com/gostor
RUN set -x \
  \
  && apk add --no-cache \
    git \
    g++ \
    ceph-dev \
    linux-headers \
  \
  && git clone https://github.com/gostor/gotgt.git gotgt \
  && cd gotgt \
  && CGO_ENABLED=0 GOOS=linux \
    go build -a -ldflags '-extldflags "-static"' -o gotgt gotgt.go

FROM busybox:latest

COPY --from=BUILD /go/src/github.com/gostor/gotgt/gotgt /
ENTRYPOINT ["/gotgt"]