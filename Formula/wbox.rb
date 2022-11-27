class Wbox < Formula
  desc "HTTP testing tool and configuration-less HTTP server"
  homepage "http://hping.org/wbox/"
  url "http://www.hping.org/wbox/wbox-5.tar.gz"
  sha256 "1589d85e83c8ee78383a491d89e768ab9aab9f433c5f5e035cfb5eed17efaa19"

  livecheck do
    url :homepage
    regex(/href=.*?wbox[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wbox"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a6a97525f3e872d0915f243ae3ef0dac0c424391c338ede034ff12084bde1311"
  end

  def install
    system "make"
    bin.install "wbox"
  end

  test do
    system "#{bin}/wbox", "www.google.com", "1"
  end
end
