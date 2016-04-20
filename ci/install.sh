# `install` phase: install stuff needed for the `script` phase

set -ex

case "$TRAVIS_OS_NAME" in
  linux)
    host=x86_64-unknown-linux-gnu
    ;;
  osx)
    host=x86_64-apple-darwin
    ;;
esac

mktempd() {
  echo $(mktemp -d 2>/dev/null || mktemp -d -t tmp)
}

install_rustup() {
  curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=$CHANNEL

  rustc -V
  cargo -V
}

install_standard_crates() {
  if [ "$host" != "$TARGET" ]; then
    rustup target add $TARGET
  fi
}

configure_cargo() {
  local prefix=
  case "$TARGET" in
    arm*-gnueabihf)
      prefix=arm-linux-gnueabihf
      ;;
    *)
      return
      ;;
  esac

  # information about the cross compiler
  $prefix-gcc -v

  # tell cargo which linker to use for cross compilation
  mkdir -p .cargo
  cat >>.cargo/config <<EOF
[target.$TARGET]
linker = "$prefix-gcc"
EOF
}

main() {
  install_rustup
  install_standard_crates
  configure_cargo

  # TODO if you need to install extra stuff add it here
}

main
