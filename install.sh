#!/bin/bash

# Install a Rust binary produced by rust-everywhere [1]
# [1]: https://github.com/japaric/rust-everywhere

# Usage:
# $ install.sh --from azerupi/mdBook --package mdBook --tag v0.0.11-rc1 --for x86_64-unknown-linux-gnu --at /home/travis/.cargo/bin
# Fetching from: https://github.com/azerupi/mdBook
# Package: mdBook
# Tag: v0.0.11-rc1
# For: x86_64-unknown-linux-gnu
# Installing at: /home/travis/.cargo/bin
# Tarball: https://github.com/azerupi/mdBook/releases/download/v0.0.11-rc1/mdBook-v0.0.11-rc1-x86_64-unknown-linux-gnu.tar.gz

# Arguments
# --from    $user/$repository (Required) The release tarball will be fetched from https://github.com/$user/$repository
# --package $package          (Optional) Package name used in the tarball
#                                        Defaults to $repository fragment of the `--from` argument
# --tag     $tag              (Optional) Release tag to download and install
#                                        Defaults to the latest release
# --for     $target           (Optional) The target triple the release was compiled for
#                                        Defaults to the host field in the rustc -Vv output
# --at      $destination      (Optional) Where to install the binary.
#                                        Defaults to $(rustc --print sysroot)/cargo/bin

set -e

err() {
    echo "error: $@" 1>&2

    if [ ! -z $tempdir ]; then
        rm -r $tempdir
    fi

    exit 1
}

while [[ $# > 1 ]]; do
    key="$1"

    case $key in
        --from)
            owner_repo="$2"
            shift
            ;;
        --package)
            package="$2"
            shift
            ;;
        --tag)
            tag="$2"
            shift
            ;;
        --for)
            target="$2"
            shift
            ;;
        --at)
            dest="$2"
            shift
            ;;
        *)
            ;;
    esac
    shift
done

if [ -z "$owner_repo" ]; then
    err 'need to specify owner and repository name using --from. Example: `install.sh --from rust-lang/rust`'
fi

if [ -z "$package" ]; then
    package=$(echo $owner_repo | cut -d'/' -f2)
fi

if [ -z "$target" ]; then
    target=$(rustc -Vv | grep host | cut -d' ' -f2)
fi

if [ -z "$dest" ]; then
    dest="$(rustc --print sysroot)/cargo/bin"
fi

url="https://github.com/$owner_repo"

echo "Fetching from: $url"
echo "Package: $package"

url+="/releases"

if [ -z "$tag" ]; then
    tag=$(curl -s "$url/latest" | cut -d'"' -f2 | rev | cut -d'/' -f1 | rev)
fi

echo "Tag: $tag"
echo "For: $target"
echo "Installing at: $dest"

url+="/download/$tag/$package-$tag-${target}.tar.gz"

echo "Tarball: $url"

tempdir=$(mktemp -d)
curl -sL $url | tar -C $tempdir -xz

for file in $(find $tempdir -type f -executable); do
    if [ -e "$dest/$(basename $file)" ]; then
        err "$(basename $file) already exists in $dest"
    else
        mkdir -p $dest
        cp $file $dest/.
    fi
done

rm -r $tempdir
