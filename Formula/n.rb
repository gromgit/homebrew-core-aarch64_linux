class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.7.1.tar.gz"
  sha256 "a7268d8922132cb4af5cddf4393b0cb6da306592b833987eb41f62fefb5c0800"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fabc76d9c70f8fe2828028123a8f298b94f11fa5192e00843e4dee5802afce5f" => :big_sur
    sha256 "dbd70d6eeb53d38588d27d22ee4e3b6f05129dc7f97bc0449f52113c0a12b1b4" => :catalina
    sha256 "dbd70d6eeb53d38588d27d22ee4e3b6f05129dc7f97bc0449f52113c0a12b1b4" => :mojave
    sha256 "dbd70d6eeb53d38588d27d22ee4e3b6f05129dc7f97bc0449f52113c0a12b1b4" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
