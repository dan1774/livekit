FROM golang:1.24-alpine AS builder

ARG TARGETPLATFORM
ARG TARGETARCH
RUN echo building for "$TARGETPLATFORM"

WORKDIR /workspace

# Copy Go Modules
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

# Copy source
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY test/ test/
COPY tools/ tools/
COPY version/ version/

# Build livekit-server
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GO111MODULE=on go build -a -o livekit-server ./cmd/server

# ===========================
# Final minimal runtime image
# ===========================
FROM alpine

# Install Go to build health-server
RUN apk add --no-cache go

# Copy livekit-server and config
COPY --from=builder /workspace/livekit-server /livekit-server
COPY config.yaml /config.yaml

# Copy and build health-server
COPY health.go /health.go
RUN go build -o health-server /health.go

# Expose health check port
EXPOSE 8080

# Run livekit in background + health server in foreground
CMD /livekit-server --config /config.yaml & ./health-server
