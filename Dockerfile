# Build an executable
FROM golang:1.19 AS build

WORKDIR /usr/src/app

COPY go.mod main.go ./

RUN CGO_ENABLED=0 go build .

# Run our executable
FROM alpine:3.14 AS RUN

COPY --from=build /usr/src/app/zero-downtime-deploy-demo .

ENTRYPOINT [ "./zero-downtime-deploy-demo" ]
