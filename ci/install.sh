set -ex

# install standard libraries
case $TARGET in
  arm-unknown-linux-gnueabihf | x86_64-unknown-linux-musl)
    if [ "$TARGET" = "arm-unknown-linux-gnueabihf" ]; then
      mkdir -p .cargo
      cat >.cargo/config <<EOF
[target.$TARGET]
linker = "arm-linux-gnueabihf-gcc"
EOF
    fi

    version=$(rustc -V | cut -d' ' -f2)
    tarball=rust-std-${version}-${TARGET}
    curl -Os http://static.rust-lang.org/dist/${tarball}.tar.gz
    tar xzf ${tarball}.tar.gz
    ${tarball}/install.sh --prefix=$(rustc --print sysroot)
    rm -r ${tarball}
    rm ${tarball}.tar.gz
    ;;
  *)
    ;;
esac
