set -ex

case $TARGET in
  # Cross compilation
  arm-unknown-linux-gnueabihf | \
  i686-apple-darwin | \
  i686-unknown-linux-gnu | \
  x86_64-unknown-linux-musl)
    cargo build --target $TARGET --verbose
    if [ "$TARGET" != "arm-unknown-linux-gnueabihf" ]; then
      cargo run --target $TARGET
      cargo test --target $TARGET
    fi
    cargo build --target $TARGET --release
    file target/$TARGET/release/hello
    ;;
  # Native build
  *)
    cargo build --verbose
    cargo run
    cargo test
    cargo build --release
    file target/release/hello
    ;;
esac
