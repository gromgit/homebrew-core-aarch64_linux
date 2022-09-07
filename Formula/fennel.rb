class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.1.0.tar.gz"
  sha256 "14873fb319ace8707a075bc4696d3691f5045686e5738822bdf4cc014d14b4b8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fennel"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9725b7888390839954e9e47c52326a69d0251932128e9a8d4fef8962af1244a5"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
