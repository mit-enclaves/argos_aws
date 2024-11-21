FROM amazonlinux:2023

# Create a directory for your binary
WORKDIR /usr/local/bin

# Copy your pre-built binary
# Note: The sealexamples file should be in the same directory as your Dockerfile
COPY sealexamples /usr/local/bin/sealexamples
RUN chmod +x /usr/local/bin/sealexamples

# Verify the binary exists and check its dependencies
RUN ls -la /usr/local/bin/sealexamples && \
    ldd /usr/local/bin/sealexamples

ENTRYPOINT ["/usr/local/bin/sealexamples"]
