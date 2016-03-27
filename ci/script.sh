# `script` phase: you usually build, test and generate docs in this phase

set -ex

# NOTE Workaround for rust-lang/rust#31907 - disable doc tests when cross compiling
# This has been fixed in the nightly channel but it would take a while to reach the other channels
disable_cross_doctests() {
  local host

  case "$TRAVIS_OS_NAME" in
    linux)
      host=x86_64-unknown-linux-gnu
      ;;
    osx)
      host=x86_64-apple-darwin
      ;;
  esac

  if [ "$host" != "$TARGET" ] && [ "$CHANNEL" != "nightly" ]; then
    if [ "$TRAVIS_OS_NAME" = "osx" ]; then
      brew install gnu-sed --default-names
    fi

    find src -name '*.rs' -type f | xargs sed -i -e 's:\(//.\s*```\):\1 ignore,:g'
  fi
}

# TODO modify this function as you see fit
# PROTIP Always pass `--target $TARGET` to cargo commands, this makes cargo output build artifacts
# to target/$TARGET/{debug,release} which can reduce the number of needed conditionals in the
# `before_deploy`/packaging phase
run_test_suite() {
  local arch=
  case $TARGET in
    # configure emulation for transparent execution of foreign binaries
    arm-unknown-linux-gnueabihf)
      export QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
      arch=arm
      ;;
    *)
      ;;
  esac

  # mount binfmt_misc
  if [ ! -z "$QEMU_LD_PREFIX" ]; then
    sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
    sudo update-binfmts --enable qemu-${arch}
  fi

  cargo build --target $TARGET --verbose
  cargo run --target $TARGET
  cargo test --target $TARGET

  # sanity check the file type
  file target/$TARGET/debug/hello
}

main() {
  disable_cross_doctests
  run_test_suite
}

main
