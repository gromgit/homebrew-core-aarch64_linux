class Ccal < Formula
  desc "Create Chinese calendars for print or browsing"
  # no https urls
  homepage "http://ccal.chinesebay.com/ccal/ccal.htm"
  url "http://ccal.chinesebay.com/ccal/ccal-2.5.3.tar.gz"
  sha256 "3d4cbdc9f905ce02ab484041fbbf7f0b7a319ae6a350c6c16d636e1a5a50df96"
  license "GPL-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?ccal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ccal"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2658e2c877cb23ba7deeddf34f874c423c98137f81961b7814392a5950bd88de"
  end

  def install
    system "make", "-e", "BINDIR=#{bin}", "install"
    system "make", "-e", "MANDIR=#{man}", "install-man"
  end

  test do
    assert_match "Year JiaWu, Month 1X", shell_output("#{bin}/ccal 2 2014")
  end
end
