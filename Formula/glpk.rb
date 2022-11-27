class Glpk < Formula
  desc "Library for Linear and Mixed-Integer Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/glpk/glpk-5.0.tar.gz"
  sha256 "4a1013eebb50f728fc601bdd833b0b2870333c3b3e5a816eeba921d95bec6f15"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/glpk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cccd676e5f76e126049ee40a584175b2524926ccc554b9011a8df2e40c26c97b"
  end

  depends_on "gmp"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp"
    system "make", "install"

    # Sanitise references to Homebrew shims
    rm "examples/Makefile"
    rm "examples/glpsol"

    # Install the examples so we can easily write a meaningful test
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "glpk.h"

      int main(int argc, const char *argv[])
      {
        printf("%s", glp_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lglpk", "-o", "test"
    assert_match version.to_s, shell_output("./test")

    system ENV.cc, pkgshare/"examples/sample.c",
                   "-L#{lib}", "-I#{include}",
                   "-lglpk", "-o", "test"
    assert_match "OPTIMAL LP SOLUTION FOUND", shell_output("./test")
  end
end
