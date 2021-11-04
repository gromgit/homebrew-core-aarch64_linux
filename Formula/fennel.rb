class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.10.0.tar.gz"
  sha256 "407d47ae50e9d7a756f47b7bd81c4bdcb0b24c40322b496e7fe7357ae1eee6e3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9f4a301802dbcb62c3fc2e6aa60d8bacacdddbd851ec1f70a99df4d93eed63ef"
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
