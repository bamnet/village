FROM golang:alpine as builder

RUN apk update && apk add git && apk add tzdata

COPY . $GOPATH/src/github.com/bamnet/village
WORKDIR $GOPATH/src/github.com/bamnet/village

ARG CGO_ENABLED=0
ARG GOARCH=amd64
ARG GOARM=6
RUN env CGO_ENABLED=${CGO_ENABLED} GOARCH=${GOARCH} GOARM=${GOARM} go build -o /go/bin/show srv/main.go

FROM scratch
COPY --from=builder /usr/local/go/lib/time/zoneinfo.zip /usr/local/go/lib/time/
COPY --from=builder /go/bin/show /go/bin/show
ENTRYPOINT ["/go/bin/show"]
CMD []
