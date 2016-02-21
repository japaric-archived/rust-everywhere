#![deny(warnings)]

use std::env;
use std::fs::File;
use std::io::Write;

fn hello() -> String {
    format!("fn main() {{ println!(\"{}: {} says hello!\") }}",
            env::var("CARGO_PKG_VERSION").unwrap(),
            env::var("TARGET").unwrap())
}

fn main() {
    File::create("src/main.rs").unwrap().write_all(hello().as_bytes()).unwrap();
}
