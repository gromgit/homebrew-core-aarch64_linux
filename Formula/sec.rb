class Sec < Formula
  desc "Event correlation tool for event processing of various kinds"
  homepage "https://simple-evcorr.sourceforge.io/"
  url "https://github.com/simple-evcorr/sec/releases/download/2.9.1/sec-2.9.1.tar.gz"
  sha256 "63a4125930a7dc8d71ee67f2ebb42e607ac0c66216e1349f279ece8f28720a34"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sec"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fe5bba73b46eef0146a04a9b7bb005832825b84b1d1ad7d52a66404f0162e5c8"
  end

  def install
    bin.install "sec"
    man1.install "sec.man" => "sec.1"
  end

  test do
    system "#{bin}/sec", "--version"
  end
end
