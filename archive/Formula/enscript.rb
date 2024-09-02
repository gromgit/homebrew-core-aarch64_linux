class Enscript < Formula
  desc "Convert text to Postscript, HTML, or RTF, with syntax highlighting"
  homepage "https://www.gnu.org/software/enscript/"
  url "https://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/enscript/enscript-1.6.6.tar.gz"
  sha256 "6d56bada6934d055b34b6c90399aa85975e66457ac5bf513427ae7fc77f5c0bb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.savannah.gnu.org/git/enscript.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/enscript"
    sha256 aarch64_linux: "504df70c20e75347c1613e10f37c3527cbe24a92f88ad96713197b1cccfb1f84"
  end

  depends_on "gettext"

  conflicts_with "cspice", because: "both install `states` binaries"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "GNU Enscript #{version}", shell_output("#{bin}/enscript -V")
  end
end
