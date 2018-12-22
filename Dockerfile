FROM golang:alpine as builder

RUN apk update && apk add git && apk add tzdata

COPY . $GOPATH/src/github.com/bamnet/village
WORKDIR $GOPATH/src/github.com/bamnet/village

RUN GOARCH=arm GOARM=6 go build -o /go/bin/show

FROM scratch
COPY --from=builder /usr/local/go/lib/time/zoneinfo.zip /usr/local/go/lib/time/
COPY --from=builder /go/bin/show /go/bin/show
ENTRYPOINT ["/go/bin/show"]
CMD []

