class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.8.0.tar.gz"
  sha256 "436b8f09d3fd732aca668f0344d449b04cc9aa28d3ac15db702ee3a9fbe66d31"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4d1d9aed1b9b8b463660e6725ccafb24a3ae4a5de5d19bb0e67f046f3996d25" => :big_sur
    sha256 "5bf84f6e6fa20624fa3eb82f07393442099dd53407704f046e90ca6642c2c44f" => :arm64_big_sur
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
