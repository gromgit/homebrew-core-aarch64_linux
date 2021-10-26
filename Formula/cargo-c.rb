class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.5.tar.gz"
  sha256 "83804d4e4c264c44372112d12c011b865b899696c16bc6a0e97bac5e12bd9112"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "76521ebc563528b80a11904b4000e065d47fe1ea52d762dbdd2efb943188d729"
    sha256 cellar: :any,                 big_sur:       "261152bdb386fefa8ae96446566511cc4e641ad68d0bf35176d310bd6d6c476a"
    sha256 cellar: :any,                 catalina:      "2742d00e8f887a6cfb1c0d006159ed29f6b4e6acea56086b969f9023d5cfcff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dac3184fdb3315d6eed841246dec368796f708aa3f1e3b91126de90d2b803579"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
