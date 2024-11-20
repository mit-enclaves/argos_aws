FROM amazonlinux:2 AS builder

# Install dependencies
RUN yum update -y && yum install -y \
    git \
    cmake3 \
    gcc-c++ \
    make \
    intel-mkl-2020.0-088 \
    wget \
    tar \
    sudo

# Create cmake symlink
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

# Clone specific SEAL repository and branch
RUN git clone -b no_tyche https://github.com/jdrean/SEAL.git /SEAL && \
    ls -la /SEAL && \
    echo "SEAL directory contents:" && \
    ls -la /SEAL

WORKDIR /SEAL
RUN cmake3 -S . -B build -DSEAL_BUILD_EXAMPLES=ON -DSEAL_USE_INTRIN=ON -DSEAL_USE_INTEL_HEXL=ON && \
    cmake3 --build build && \
    cmake3 --install build && \
    echo "Build directory contents:" && \
    ls -la /SEAL/build/bin && \
    test -f /SEAL/build/bin/sealexamples || (echo "sealexamples not found!" && exit 1)

# Start fresh with verified files
FROM amazonlinux:2

COPY --from=builder /SEAL/build/bin/sealexamples /sealexamples
COPY --from=builder /usr/local/lib64/lib* /usr/local/lib64/
COPY --from=builder /usr/lib64/libmkl* /usr/lib64/

# Verify the binary exists
RUN ls -la /sealexamples && \
    ldd /sealexamples

ENTRYPOINT ["/sealexamples"]
