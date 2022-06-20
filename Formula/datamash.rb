class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.7.tar.gz"
  sha256 "574a592bb90c5ae702ffaed1b59498d5e3e7466a8abf8530c5f2f3f11fa4adb3"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/datamash"
    sha256 aarch64_linux: "8e874e0d4722d8513ba652f09e41bbc655f17ef396e53b6af97eda7c0ecf8e61"
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "55", pipe_output("#{bin}/datamash sum 1", shell_output("seq 10")).chomp
  end
end
