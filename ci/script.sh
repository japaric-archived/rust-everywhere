set -ex

case $TARGET in
  arm-unknown-linux-gnueabihf | x86_64-unknown-linux-musl)
    cargo build --target $TARGET
    if [ "$TARGET" = "x86_64-unknown-linux-musl" ]; then
      cargo run --target $TARGET
      cargo test --target $TARGET
    fi
    cargo build --target $TARGET --release
    file target/$TARGET/release/hello
    ;;
  *)
    cargo build
    cargo run
    cargo test
    cargo build --release
    file target/release/hello
    ;;
esac
