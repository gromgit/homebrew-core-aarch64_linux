class Fuego < Formula
  desc "Collection of C++ libraries for the game of Go"
  homepage "https://fuego.sourceforge.io/"
  url "https://svn.code.sf.net/p/fuego/code/trunk", revision: "1981"
  version "1.1.SVN"
  revision 5
  head "https://svn.code.sf.net/p/fuego/code/trunk"

  bottle do
    sha256 arm64_monterey: "5a3e590497e0820c464ad1502ff85099abc788ebb8bbd5673a3f13a3938974be"
    sha256 arm64_big_sur:  "17218e8a637744273cd02101fb46ba305508c5629ffc8362cf369eb8727d1e25"
    sha256 monterey:       "48789049382de09888cbc9584dcb72c5ec54d597868539fc739dfad016b54d70"
    sha256 big_sur:        "cc9854427b57339e75b30fe71d354412b641e703254e9d7589e0968af2921848"
    sha256 catalina:       "a3a74c3c91cb24b3a4bc80c416a7c763c9dcb4ea2864c9b1b24eb94b0829439a"
    sha256 x86_64_linux:   "01cd8bb74fd428687faf32dd6a0275071291fa7647133f927579d0db5d897f09"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install", "LIBS=-lpthread"
  end

  test do
    input = <<~EOS
      genmove white
      genmove black
    EOS
    output = pipe_output("#{bin}/fuego 2>&1", input, 0)
    assert_match "Forced opening move", output
    assert_match "maxgames", shell_output("#{bin}/fuego --help")
  end
end
