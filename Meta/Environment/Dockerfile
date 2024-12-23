FROM debian:bullseye-slim

# Get packages
RUN apt-get update && apt-get install -y \
    build-essential \
    grub-pc-bin \
    grub-common \
    xorriso \
    gcc \
    binutils \
    curl \
    tree \
    && apt-get clean

# Get rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup target add x86_64-unknown-none

# Get ENV
WORKDIR /build
CMD ["bash"]
