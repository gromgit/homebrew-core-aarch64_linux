class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.7.0.tar.gz"
  sha256 "5bb07b35d88840dfeaa90ed29c3d9282357d360b07efeb497901871d6710e59d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "eeceef32216dce9edeb2f213d9f6433f0a0f40784146a15c2a2ca29dec94baa4" => :catalina
    sha256 "33178e611d635926983ae9c254601414fb855a967eda93e1d257b2d0bf4859cc" => :mojave
    sha256 "07287f0807062132269ac48897285118c2aa50c404088cb6cef159571a848822" => :high_sierra
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
