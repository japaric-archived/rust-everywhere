set -ex

mkdir deploy
cp target/$TARGET/release/hello deploy/hello

cd deploy
tar czf hello-${TRAVIS_TAG}-${TARGET}.tar.gz hello
