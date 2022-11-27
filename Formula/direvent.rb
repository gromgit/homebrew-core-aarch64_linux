class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "https://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftp.gnu.org/gnu/direvent/direvent-5.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/direvent/direvent-5.2.tar.gz"
  sha256 "239822cdda9ecbbbc41a69181b34505b2d3badd4df5367e765a0ceb002883b55"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/direvent"
    sha256 aarch64_linux: "5d506312cc95f1dff2f1153be7dcc5f7a1764a7f44cf347a0d057085304d7601"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end
