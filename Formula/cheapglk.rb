class Cheapglk < Formula
  desc "Extremely minimal Glk library"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/cheapglk-106.tar.gz"
  version "1.0.6"
  sha256 "2753562a173b4d03ae2671df2d3c32ab7682efd08b876e7e7624ebdc8bf1510b"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?cheapglk[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?CheapGlk library v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cheapglk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5b363f781f95c22e14a997d2f7a3daabe72f2e856d4bf8bb4483086fd8dd9879"
  end

  keg_only "it conflicts with other Glk libraries"

  def install
    system "make"

    lib.install "libcheapglk.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.cheapglk"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "glk.h"
      #include "glkstart.h"

      glkunix_argumentlist_t glkunix_arguments[] = {
          { NULL, glkunix_arg_End, NULL }
      };

      int glkunix_startup_code(glkunix_startup_t *data)
      {
          return TRUE;
      }

      void glk_main()
      {
          glk_exit();
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheapglk", "-o", "test"
    assert_match version.to_s, pipe_output("./test", "echo test", 0)
  end
end
