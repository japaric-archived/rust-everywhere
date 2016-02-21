set -ex

# install standard libraries
case $TARGET in
  x86_64-unknown-linux-musl)
    version=$(rustc -V | cut -d' ' -f2)
    tarball=rust-std-${version}-x86_64-unknown-linux-musl
    curl -Os http://static.rust-lang.org/dist/${tarball}.tar.gz
    tar xzf ${tarball}.tar.gz
    ${tarball}/install.sh --prefix=$(rustc --print sysroot)
    rm -r ${tarball}
    rm ${tarball}.tar.gz
    ;;
  *)
    ;;
esac
