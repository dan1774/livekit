RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GO111MODULE=on go build -a -o livekit-server ./cmd/server

# ========================
# Final container
# ========================
FROM alpine

# Install minimal tools to run health server
RUN apk add --no-cache go

# Copy compiled livekit binary
COPY --from=builder /workspace/livekit-server /livekit-server

# Copy config
COPY config.yaml /config.yaml

# Copy and build health check Go app
COPY health.go /health.go
RUN go build -o health-server /health.go

#Hey, my app is alive and listening on port 8080 — check here!
EXPOSE 8080

# Run both livekit and health server
CMD /livekit-server --config /config.yaml & ./health-server
