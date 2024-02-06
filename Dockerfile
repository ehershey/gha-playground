FROM alpine:latest as builder
WORKDIR /app
COPY . ./
# This is where one could build the application code as well.
RUN apk add go
RUN go build

# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine:latest
RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy binary to production image.
COPY --from=builder --chmod=755 /app/start.sh /app/start.sh
COPY --from=builder --chmod=755 /app/gha-playground /app/gha-playground

# Run on container startup.
CMD ["/app/start.sh"]
