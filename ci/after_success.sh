set -ex

mkdir deploy

case $TARGET in
  x86_64-unknown-linux-musl)
    cp target/$TARGET/release/hello deploy/$TARGET-hello
    ;;
  *)
    cp target/release/hello deploy/$TARGET-hello
    ;;
esac
