set -ex

case $TARGET in
  arm-unknown-linux-gnueabihf | x86_64-unknown-linux-musl)
    cargo build --target $TARGET
    [ "$TARGET" = "x86_64-unknonwn-linux-musl" ] && cargo run --target $TARGET
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
