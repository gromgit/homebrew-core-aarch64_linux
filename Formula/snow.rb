class Snow < Formula
  desc "Whitespace steganography: coded messages using whitespace"
  homepage "https://web.archive.org/web/20200701063014/www.darkside.com.au/snow/"
  # The upstream website seems to be rejecting curl connections.
  # Consistently returns "HTTP/1.1 406 Not Acceptable".
  url "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/snow-20130616.tar.gz"
  sha256 "c0b71aa74ed628d121f81b1cd4ae07c2842c41cfbdf639b50291fc527c213865"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/snow"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2e6bf0ab5eb9a9616bf159d819c58958f60364da9c75ac9eea4422b71f654c3a"
  end

  def install
    system "make"
    bin.install "snow"
    man1.install "snow.1"
  end

  test do
    touch "in.txt"
    touch "out.txt"
    system "#{bin}/snow", "-C", "-m", "'Secrets Abound Here'", "-p",
           "'hello world'", "in.txt", "out.txt"
    # The below should get the response 'Secrets Abound Here' when testing.
    system "#{bin}/snow", "-C", "-p", "'hello world'", "out.txt"
  end
end
