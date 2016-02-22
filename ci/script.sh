set -ex

cargo build --target $TARGET --verbose
if [ "$TARGET" != "arm-unknown-linux-gnueabihf" ]; then
  cargo run --target $TARGET
  cargo test --target $TARGET
fi
cargo build --target $TARGET --release
file target/$TARGET/release/hello
