class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.5.tar.gz"
  sha256 "94a05e61af26163a82d529639a3c3859c3f2e0ffb94260fca0d5856f5ab62021"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "57f7c2d6af3ed55a96d0dfffab6f525a10e82e6a82ce3a0cb881b682ad55d9ca"
    sha256 cellar: :any,                 arm64_big_sur:  "7eac381adc7c6dff2a9a52d5d6cbc5d15ad07fc3c6230de64cf3d17f289c6e73"
    sha256 cellar: :any,                 monterey:       "ac28eed7ade690810c21e366156f094ac5ac4490a2e175c12ba672a627e213d1"
    sha256 cellar: :any,                 big_sur:        "21f206134a6529b32c4d05719ab5ee069583498ef74958e3fc545b919a3fc1c9"
    sha256 cellar: :any,                 catalina:       "05e55d678123adca716582110590856e782578e445efdd55871387e41ad79d4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88edb6ad9013be4eade7853c45b778d2ffb3288e2ec493c3c964bd7c758165f5"
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
