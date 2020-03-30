class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.99.0.tar.gz"
  sha256 "174024310c1563097a6613a0d3f7539d11a9a86517cd67ce533849065de08a11"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "552d880dbedf2fbf50015664ae9618586e455043c26b2656474d267556122293" => :catalina
    sha256 "f3157437e1027cf076470c96891930210fca71746eebea354261b98a0cfd4876" => :mojave
    sha256 "0d22a3a929f3fd82f96ed52813ec0ed3b88c2a266eb233ead6c5241f4df3167c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "lg2"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
