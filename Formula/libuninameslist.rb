class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20200313/libuninameslist-dist-20200313.tar.gz"
  sha256 "a8029cd38a32c85da30015ac2fc0a923c25dfc41590f1717cc64756218403183"

  bottle do
    cellar :any
    sha256 "1d485ffcd3038b162c9706ae8829f22a5739bfb2ebcf49b30086ce1690055f34" => :catalina
    sha256 "e74e645c00f59f1e570f82516c537a2bbfa9c55817687bca5a71390f7ada12dd" => :mojave
    sha256 "52274b73bc63e0cf06e394b08595e644e5ac1d220da90e00e6fbde18c1459dc1" => :high_sierra
    sha256 "4a77333f42e0c1acff273a95a750ba5800a9376cf7d1954c2761b93b95901329" => :sierra
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end
