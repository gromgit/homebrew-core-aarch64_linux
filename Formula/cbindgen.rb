class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/eqrion/cbindgen"
  url "https://github.com/eqrion/cbindgen/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "5d693ab54acc085b9f2dbafbcf0a1f089737f7e0cb1686fa338c2aaa05dc7705"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cbindgen"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "30ae0ea5de651c7efd6c17aa4cd05b9b99ce1a93c3e58eff2aa8472c92a100b6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end
