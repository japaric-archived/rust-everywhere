set -e

mkdir deploy

case $TARGET in
  x86_64-unknown-linux-gnu)
    cp target/release/hello deploy/$TARGET-hello
    ;;
  x86_64-unknown-linux-musl)
    cp target/$TARGET/release/hello deploy/$TARGET-hello
    ;;
esac

dpl --provider=releases --api-key="$GH_TOKEN" --file=deploy/$TARGET-hello
