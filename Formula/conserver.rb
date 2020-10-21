class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/conserver/conserver/releases/download/v8.2.6/conserver-8.2.6.tar.gz"
  sha256 "33b976a909c6bce8a1290810e26e92bfa16c39bca19e1f8e06d5d768ae940734"
  license "BSD-3-Clause"

  livecheck do
    url "https://github.com/conserver/conserver/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ce9d095a9e435480fe4a8eb2e73c0732fe0d7eda89aafc98e0599453eaa8f626" => :catalina
    sha256 "70283393748aaf6397ea4b0bcdda5f7192597da2093e8fe0c21fcbc89cd5e900" => :mojave
    sha256 "e5de5fdc13fd75c8ab4cb11f0a86408b63b2683ac9aacf573d7df0500dc38210" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
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
