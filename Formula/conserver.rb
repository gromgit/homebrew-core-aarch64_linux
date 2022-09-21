class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/bstansell/conserver/releases/download/v8.2.6/conserver-8.2.6.tar.gz"
  sha256 "33b976a909c6bce8a1290810e26e92bfa16c39bca19e1f8e06d5d768ae940734"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/conserver"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5978950c85adec89019672e21484a3f9aff6afde07e0760ca9ea25b278937ddb"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl", "--with-ipv6"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
