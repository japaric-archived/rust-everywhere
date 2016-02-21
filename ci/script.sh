set -ex

case $TARGET in
  x86_64-unknown-linux-musl)
    cargo build --target $TARGET
    cargo run --target $TARGET
    cargo build --target $TARGET --release
    file target/$TARGET/release/hello
    ;;
  *)
    cargo build
    cargo run
    cargo build --release
    file target/release/hello
    ;;
esac
