class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage "http://piumarta.com/software/peg/"
  url "http://piumarta.com/software/peg/peg-0.1.15.tar.gz"
  sha256 "b6736ca15e5eb9154596e620ebad94a4705c7e597fc97b11219a90fc171faef2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9cd7035c2fbe976a10b5488b4cf036fadfb3fe221107cee67ca049c3e662510" => :el_capitan
    sha256 "62c8a46b9d297ccf1084b4267bfd857418c319d772fe65fe6e38de94e14fc402" => :yosemite
    sha256 "6ff03f8a899d66a74b7b5dcb10fdbf02db64bd3acbff08eb89ea21805381b473" => :mavericks
  end

  def install
    system "make", "all"
    bin.install %w[peg leg]
    man1.install gzip("src/peg.1")
  end
end
