set -ex

mkdir deploy

case $TARGET in
  x86_64-unknown-linux-musl)
    cp target/$TARGET/release/hello deploy/hello
    ;;
  *)
    cp target/release/hello deploy/hello
    ;;
esac

cd deploy
tar czf hello-${TRAVIS_TAG}-${TARGET}.tar.gz
