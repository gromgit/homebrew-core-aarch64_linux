class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "https://www.nongnu.org/pngpp/"
  url "https://download.savannah.gnu.org/releases/pngpp/png++-0.2.10.tar.gz"
  sha256 "998af216ab16ebb88543fbaa2dbb9175855e944775b66f2996fc945c8444eee1"

  livecheck do
    url "https://download.savannah.gnu.org/releases/pngpp/"
    regex(/href=.*?png\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/png++"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d44bee18f433cdb8e171c16ca013924113ca74640de8ff30d4e4fb69e8b256f8"
  end

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <png++/png.hpp>
      int main() {
        png::image<png::rgb_pixel> image(200, 300);
        if (image.get_width() != 200) return 1;
        if (image.get_height() != 300) return 2;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
