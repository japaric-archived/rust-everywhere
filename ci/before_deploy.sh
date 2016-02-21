set -ex

mkdir deploy

case $TARGET in
  # Cross compiled
  arm-unknown-linux-gnueabihf | \
  i686-unknown-linux-gnu | \
  x86_64-unknown-linux-musl)
    cp target/$TARGET/release/hello deploy/hello
    ;;
  # Native builds
  *)
    cp target/release/hello deploy/hello
    ;;
esac

cd deploy
tar czf hello-${TRAVIS_TAG}-${TARGET}.tar.gz hello
