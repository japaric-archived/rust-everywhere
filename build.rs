#![deny(warnings)]

extern crate rustc_version;

use std::env;
use std::fs::File;
use std::io::Write;

fn hello() -> String {
    let meta = rustc_version::version_meta();

    format!("fn main() {{ println!(\"{}: {} says hello!\nCompiled with rust-{} ({:?} channel)\") }}\n#[test] fn ok() {{ assert!(true) }}",
            env::var("CARGO_PKG_VERSION").unwrap(),
            env::var("TARGET").unwrap(),
            meta.semver,
            meta.channel)
}

fn main() {
    File::create("src/main.rs").unwrap().write_all(hello().as_bytes()).unwrap();
}
