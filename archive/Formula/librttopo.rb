class Librttopo < Formula
  desc "RT Topology Library"
  homepage "https://git.osgeo.org/gitea/rttopo/librttopo"
  url "https://git.osgeo.org/gitea/rttopo/librttopo/archive/librttopo-1.1.0.tar.gz"
  sha256 "2e2fcabb48193a712a6c76ac9a9be2a53f82e32f91a2bc834d9f1b4fa9cd879f"
  license "GPL-2.0-or-later"
  head "https://git.osgeo.org/gitea/rttopo/librttopo.git", branch: "master"

  livecheck do
    url :head
    regex(/^(?:librttopo[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/librttopo"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0491f6f9543a4381d0c47952b9182b9cece881bc052859fb5a5c90a27cd21fab"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "geos"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librttopo.h>

      int main(int argc, char *argv[]) {
        printf("%s", rtgeom_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lrttopo", "-o", "test"
    assert_equal stable.version.to_s, shell_output("./test")
  end
end
