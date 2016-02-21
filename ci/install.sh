set -ex

# install standard libraries needed for cross compilation
case $TARGET in
  armv7-unknown-linux-gnueabihf | x86_64-unknown-linux-musl)
    version=$(rustc -V | cut -d' ' -f2)

    if [ "$TARGET" = "armv7-unknown-linux-gnueabihf" ]; then
      # There is no official standard libraries for this target, so we use the
      # more generic ones
      tarball=rust-std-${version}-arm-unknown-linux-gnueabihf

      arm-linux-gnueabihf-gcc -v

      # configure the linker for cross compilation
      mkdir -p .cargo
      cat >.cargo/config <<EOF
[target.$TARGET]
linker = "arm-linux-gnueabihf-gcc"
EOF
    else
      tarball=rust-std-${version}-${TARGET}
    fi

    curl -Os http://static.rust-lang.org/dist/${tarball}.tar.gz
    tar xzf ${tarball}.tar.gz
    ${tarball}/install.sh --prefix=$(rustc --print sysroot)
    rm -r ${tarball}
    rm ${tarball}.tar.gz
    ;;
  *)
    ;;
esac
