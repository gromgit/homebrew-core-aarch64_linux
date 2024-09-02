class Glktermw < Formula
  desc "Terminal-window Glk library with Unicode support"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/glktermw-104.tar.gz"
  version "1.0.4"
  sha256 "5968630b45e2fd53de48424559e3579db0537c460f4dc2631f258e1c116eb4ea"

  livecheck do
    url :homepage
    regex(/href=.*?glktermw[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?GlkTerm library v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/glktermw"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b5c4251740272eb1223f4598b84805715102eb17c0adb9b47723263696fa8ebe"
  end

  keg_only "conflicts with other Glk libraries"

  uses_from_macos "ncurses"

  def install
    inreplace "gtoption.h", "/* #define LOCAL_NCURSESW */", "#define LOCAL_NCURSESW"
    inreplace "Makefile", "-lncursesw", "-lncurses"

    system "make"

    lib.install "libglktermw.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glktermw"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglktermw", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
