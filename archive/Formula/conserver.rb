class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/bstansell/conserver/releases/download/v8.2.7/conserver-8.2.7.tar.gz"
  sha256 "0607f2147a4d384f1e677fbe4e6c68b66a3f015136b21bcf83ef9575985273d8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/conserver"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7eeb08a0aa968e0363b24f4c735bb4c999dc5244cfb06dfa768f2a538edcf9db"
  end

  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"

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
