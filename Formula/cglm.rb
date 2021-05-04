class Cglm < Formula
  desc "Optimized OpenGL/Graphics Math (glm) for C"
  homepage "https://github.com/recp/cglm"
  url "https://github.com/recp/cglm/archive/v0.8.2.tar.gz"
  sha256 "b578e3c9d3d93d83001e59c2f1e412043089f05684836f7ea570e9cb8f60df22"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d71507b61912470913e98d1720b385162b4f0fd0cdc8d895e939d809e00fa636"
    sha256 cellar: :any, big_sur:       "ed08a26dddf43f709d962c8f691c4bbee9df9aae21bfb97faecfcc4b05d2be72"
    sha256 cellar: :any, catalina:      "6a50abbcea2f44d990401a51426f4cb7e30d8306fd000322f987561ca1f515fd"
    sha256 cellar: :any, mojave:        "20de453a0e9fce13370416237d809023872c6e3aefcd2689a4a381c2e3cf1c91"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cglm/cglm.h>
      #include <assert.h>

      int main() {
        vec3 x = {1.0f, 0.0f, 0.0f},
             y = {0.0f, 1.0f, 0.0f},
             z = {0.0f, 0.0f, 1.0f};
        vec3 r;

        glm_cross(x, y, r);
        assert(glm_vec3_eqv_eps(r, z));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c", "-o", "test"
    system "./test"
  end
end
