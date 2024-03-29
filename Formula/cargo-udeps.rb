class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.32.tar.gz"
  sha256 "2ec9a861885a2ba3a523166636e08dd40116fdd870f088f84ca8d57949087e84"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cargo-udeps"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "76b38f4a0512954210bbbf9398469e5262d0eec15ceabbfda4fea2cd24bbf7d8"
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
