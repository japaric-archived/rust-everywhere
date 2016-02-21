set -ex

if [ $STATIC = yes ]; then
  triple=x86_64-unknown-linux-musl

  cargo build --target ${triple}
  cargo run --target ${triple}
  cargo build --target ${triple} --release
  file target/${triple}/release/hello
else
  cargo build
  cargo run
  cargo build --release
  file target/release/hello
  ldd target/release/hello
fi
