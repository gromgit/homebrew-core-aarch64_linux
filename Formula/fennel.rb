class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.4.2.tar.gz"
  sha256 "390e28fb341681fc0a9237c6aea55d1afb4bffb422fbdd6619f83589407e2bc0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9577b157dd309dbc8f975898e24124246043a22e812abf5c8763e88872b2dcf1" => :catalina
    sha256 "9577b157dd309dbc8f975898e24124246043a22e812abf5c8763e88872b2dcf1" => :mojave
    sha256 "9577b157dd309dbc8f975898e24124246043a22e812abf5c8763e88872b2dcf1" => :high_sierra
  end

  depends_on "lua"

  def install
    system "make", "fennel"
    bin.install "fennel"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
