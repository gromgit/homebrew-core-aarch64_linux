class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.8.0/sfk-1.9.8.tar.gz"
  version "1.9.8.0"
  sha256 "837c7a3fabd1549c0ea5748d05ece5f259d906358226ce04799c4c13e59f1968"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sfk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6120b9b11de92a3e53d9ccaa5e5d089383e3c56e8a72c19998f5e78f09dd7f13"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
