# `script` phase: you usually build, test and generate docs in this phase

set -ex

# TODO modify this phase as you see fit
# PROTIP Always pass `--target $TARGET` to cargo commands, this makes cargo output build artifacts
# to target/$TARGET/{debug,release} which can reduce the number of needed conditionals in the
# `before_deploy`/packaging phase

case "$TRAVIS_OS_NAME" in
  linux)
    host=x86_64-unknown-linux-gnu
    sedi="sed -i"
    ;;
  osx)
    host=x86_64-apple-darwin
    sedi="sed -i ''"
    ;;
esac

# NOTE Workaround for rust-lang/rust#31907 - disable doc tests when cross compiling
if [ "$host" != "$TARGET" ]; then
  find src -name '*.rs' -type f | xargs $sedi -e 's:\(//.\s*```\):\1 ignore,:g'
fi

case $TARGET in
  # use an emulator to run the cross compiled binaries
  arm-unknown-linux-gnueabihf)
    # build tests but don't run them
    cargo test --target $TARGET --no-run

    # run tests in emulator
    find target/$TARGET/debug -maxdepth 1 -executable -type f | \
      xargs qemu-arm -L /usr/arm-linux-gnueabihf

    # build the main executable
    cargo build --target $TARGET

    # run the main executable using the emulator
    qemu-arm -L /usr/arm-linux-gnueabihf target/$TARGET/debug/hello
    ;;
  *)
    cargo build --target $TARGET --verbose
    cargo run --target $TARGET
    cargo test --target $TARGET
    ;;
esac

# sanity check the file type
file target/$TARGET/debug/hello
