FROM rust:1.54 AS builder

WORKDIR /usr/local/src/robbb

COPY Cargo.toml Cargo.lock ./
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/usr/local/src/robbb/target \
    mkdir src && echo "fn main() {}" >src/main.rs && cargo build --release && rm -rf src

COPY sqlx-data.json ./
COPY migrations ./migrations
COPY src ./src

ARG VERSION
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/usr/local/src/robbb/target \
    cargo build --release \
    && cp target/release/robbb .

FROM debian:bullseye-slim

COPY --from=builder /usr/local/src/robbb/robbb /usr/local/bin/robbb

CMD ["robbb"]
