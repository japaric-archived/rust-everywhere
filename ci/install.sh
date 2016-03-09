# `install` phase: install stuff needed for the `script` phase

set -ex

# Install multirust
git clone https://github.com/brson/multirust
pushd multirust
./build.sh
./install.sh --prefix=~/multirust
multirust default $CHANNEL
popd

case "$TRAVIS_OS_NAME" in
  linux)
    host=x86_64-unknown-linux-gnu
    ;;
  osx)
    host=x86_64-apple-darwin
    ;;
esac

# Install standard libraries needed for cross compilation
if [ "$host" != "$TARGET" ]; then
  if [ "$TARGET" = "arm-unknown-linux-gnueabihf" ]; then
    # information about the cross compiler
    arm-linux-gnueabihf-gcc -v

    # tell cargo which linker to use for cross compilation
    mkdir -p .cargo
    cat >.cargo/config <<EOF
[target.$TARGET]
linker = "arm-linux-gnueabihf-gcc"
EOF
  fi

  if [ "$CHANNEL" = "nightly" ]; then
    multirust add-target nightly $TARGET
  else
    if [ "$CHANNEL" = "stable" ]; then
      # e.g. 1.6.0
      version=$(rustc -V | cut -d' ' -f2)
    else
      version=beta
    fi

    tarball=rust-std-${version}-${TARGET}

    curl -Os http://static.rust-lang.org/dist/${tarball}.tar.gz

    tar xzf ${tarball}.tar.gz

    ${tarball}/install.sh --prefix=$(rustc --print sysroot)

    rm -r ${tarball}
    rm ${tarball}.tar.gz
  fi
fi

# TODO if you need to install extra stuff add it here
