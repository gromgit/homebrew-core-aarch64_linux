class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.10.3.tar.gz"
  sha256 "b754d7020dfbf696357bc933ca571113d1d085a18519e87852229a32b0f87ca0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f9b963588a8909c0472def193ea7ee550fe77969d95e7644eee6b74165f83af7"
    sha256 cellar: :any,                 arm64_big_sur:  "a329b1e80b96c7da0cdfce2acec2c62cd5ad6c26dd1381d82e5bccf63a523abd"
    sha256 cellar: :any,                 monterey:       "529a39a60c50f1db53cca8b6aaf3eac5f5b543d9ddee70083829fcd18fb2cacf"
    sha256 cellar: :any,                 big_sur:        "559323c6c7fbaa559ee82a385401ca2e4c875446cde74b6f31c73e36372b67e8"
    sha256 cellar: :any,                 catalina:       "89f30f4f0ae7f45fa0581111718811851224ce719f99bc8239e416f2067074c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b162056b872af65a1327e6607bc12e434e470793ebaec98ca5de68762c471ae8"
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
