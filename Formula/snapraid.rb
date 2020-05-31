class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://snapraid.sourceforge.io/"
  url "https://github.com/amadvance/snapraid/releases/download/v11.5/snapraid-11.5.tar.gz"
  sha256 "1f5267261bdbcf4d48b9359ce67184df11905590739140f740327fb73bcecafa"

  bottle do
    cellar :any_skip_relocation
    sha256 "428afbfefb0bba0949f706e908c9837044b484c4af591525b36ad35121a5e660" => :catalina
    sha256 "cee9e0baa9510de52e801afb91c003d02493d2dc15f679c1da9aabec05180501" => :mojave
    sha256 "e50021d135a1ce085093c8d7a50aa559c786919fca20355cb5cda6db213da822" => :high_sierra
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
