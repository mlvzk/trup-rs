FROM rust:1.54 AS builder

WORKDIR /usr/local/src/robbb

COPY Cargo.toml Cargo.lock sqlx-data.json ./
COPY migrations ./migrations
COPY src ./src

ARG VERSION
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/usr/local/src/robbb/target \
    cargo build \
    && cp target/debug/robbb .

FROM debian:bullseye-slim

COPY --from=builder /usr/local/src/robbb/robbb /usr/local/bin/robbb

CMD ["robbb"]