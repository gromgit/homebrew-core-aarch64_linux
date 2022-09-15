class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.33.tar.gz"
  sha256 "edb369e61b658f68561be93a88634e0ee7322175b4c19627b601d67a3417fd85"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c723b865d0831a242ef0e3699bcd53799d04e590ac87a79057ae357ae03beb33"
    sha256 cellar: :any,                 arm64_big_sur:  "f815ad8fa9c513af2bddcaaa3e9055308a45de2b08c0cd02f5a0b8bfbb167cb2"
    sha256 cellar: :any,                 monterey:       "4f2e92806f94e558cf227e60523eeea71cd4431ae3856266a9370da526423307"
    sha256 cellar: :any,                 big_sur:        "9f3919ba2ca2021edf95d47279d8f1416ded22a7c54a669a3e61c5b92f3d0f4b"
    sha256 cellar: :any,                 catalina:       "9bcb6238aaa6638eb38521676c256cd6071a5484499cf1f8600ecbdc789f5c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e420861db5d9576f32d9c6ee5930e7d4ff5eb045bc7f08fb2a3212c21d9823a7"
  end

  depends_on "rust" => [:build, :test]
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      EOS

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end
  end
end
