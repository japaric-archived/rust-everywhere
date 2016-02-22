# `script` phase: you usually build, test and generate docs in this phase

set -ex

# TODO modify this phase as you see fit
# PROTIP Always pass `--target $TARGET` to cargo commands, this makes cargo output build artifacts
# to target/$TARGET/{debug,release} which can reduce the number of needed conditionals in the
# `before_deploy`/packaging phase

cargo build --target $TARGET --verbose

# can't run binaries for this target
if [ "$TARGET" != "arm-unknown-linux-gnueabihf" ]; then
  cargo run --target $TARGET
  cargo test --target $TARGET
fi

cargo build --target $TARGET --release

# sanity check the file type
file target/$TARGET/release/hello
