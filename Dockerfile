# ALPINE: Build executable binary
FROM golang:alpine AS builder

# Install Git
RUN apk update && apk add --no-cache git

# ADD . /go/src/unicorn

# create a working directory
WORKDIR $GOPATH/src/unicorn
COPY . .

RUN go get github.com/gin-gonic/gin
RUN go get github.com/go-playground/validator

RUN go get -d -v

# RUN go get -d -v ./...
# RUN go install -v ./...

# RUN go build -o /go/bin/unicorn
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/unicorn

# SCRATCH: build small image
FROM scratch
COPY --from=builder . .
#COPY --from=builder /go/bin/unicorn /

EXPOSE 8080

ENTRYPOINT ["/go/bin/unicorn"]
