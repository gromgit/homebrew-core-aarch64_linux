class Libbdplus < Formula
  desc "Implements the BD+ System Specifications"
  homepage "https://www.videolan.org/developers/libbdplus.html"
  url "https://download.videolan.org/pub/videolan/libbdplus/0.2.0/libbdplus-0.2.0.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/videolan/libbdplus/0.2.0/libbdplus-0.2.0.tar.bz2"
  sha256 "b93eea3eaef33d6e9155d2c34b068c505493aa5a4936e63274f4342ab0f40a58"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libbdplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libbdplus"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0b1b915f3d4636e3c380a98e28954e00c24f3371a845a102b2d05c8e4cb1ee3a"
  end

  head do
    url "https://code.videolan.org/videolan/libbdplus.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbdplus/bdplus.h>
      int main() {
        int major = -1;
        int minor = -1;
        int micro = -1;
        bdplus_get_version(&major, &minor, &micro);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lbdplus", "-o", "test"
    system "./test"
  end
end
