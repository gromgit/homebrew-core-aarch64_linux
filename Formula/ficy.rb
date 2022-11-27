class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "https://www.thregr.org/~wavexx/software/fIcy/"
  url "https://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.21.tar.gz"
  sha256 "8564b16d3a52fa6dc286b02bfcc19e4acdc148c30f1750ca144e2ea47c84fd81"
  license "LGPL-2.1-only"
  head "https://gitlab.com/wavexx/fIcy.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{href=.*?releases/fIcy[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ficy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b614c16aeafa9f71fad81b55ad0462dec0ef4cfc91d3c2a4e88682fff67a8941"
  end

  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/fResync", "-n", "1", "test.mp3"
  end
end
