FROM golang:alpine as BUILD
ENV VERSION v0.1.0

WORKDIR /go/src/github.com/gostor
RUN set -x \
  \
  && apk add --no-cache \
    git \
    g++ \
    ceph-dev \
    linux-headers \
  \
  && git clone -b $VERSION https://github.com/gostor/gotgt.git gotgt \
  && cd gotgt \
  && CGO_ENABLED=0 GOOS=linux \
    go build -v -a -ldflags '-w -s -extldflags "-static"' -o gotgt gotgt.go

FROM scratch

COPY --from=BUILD /go/src/github.com/gostor/gotgt/gotgt /
ENTRYPOINT ["/gotgt"]