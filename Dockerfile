# syntax=docker/dockerfile:1
FROM rust:1.95-bookworm AS builder
RUN apt-get update && apt-get install -y --no-install-recommends cmake clang pkg-config && rm -rf /var/lib/apt/lists/*
WORKDIR /build
COPY Cargo.toml Cargo.lock rust-toolchain.toml ./
COPY src ./src
RUN cargo build --locked --release

FROM gcr.io/distroless/cc-debian13:nonroot@sha256:cb87acc574abe719b6e5c547384defa2f7b1f24af9605d3f618cf852495d8be2
COPY --from=builder --chmod=0555 /build/target/release/openshell-sandbox-proxy /openshell-sandbox-proxy
USER 65532:65532
ENTRYPOINT ["/openshell-sandbox-proxy"]
