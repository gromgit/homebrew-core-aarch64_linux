class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.2.tar.gz"
  sha256 "cf2601b584c7a6779a53622600f496e9f70ad5b1854369733547cecda4044699"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "488dffff6c2f57d0e8e2249250f37eea40997f6b151678a90ac68983f1f3e53b"
    sha256 cellar: :any,                 arm64_big_sur:  "04d923cefae2bcaf347638f76daec8fee0ea1ff1f6a184a9a99ee70834652227"
    sha256 cellar: :any,                 monterey:       "edc0c4842a6022fdce12928ee6fda9bad956d7344d3e22c0f00abee5496560e5"
    sha256 cellar: :any,                 big_sur:        "d4e9728fd705799345148c447ced7b6d572c4edb63a3dfa2bfe979b8c01a370d"
    sha256 cellar: :any,                 catalina:       "30e7a42e02e3176ce7e415c870f7faac7010a514faea9e06af2b18f913af4c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "854d7cf55f57a098e129a675d1fc7662bbd66d7684638deae663a7b4793a81a8"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

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
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end
  end
end
