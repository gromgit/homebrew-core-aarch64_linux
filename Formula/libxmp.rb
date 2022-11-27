class Libxmp < Formula
  desc "C library for playback of module music (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.5.0/libxmp-4.5.0.tar.gz"
  sha256 "7847d262112d14e8442f44e5ac6ed9ddbca54c251284720b563c852b31f26e75"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxmp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9f0399b46d9a5d9911a610be24e9a1a140012a1d740f0c91b4aa315e63a1c481"
  end

  head do
    url "https://git.code.sf.net/p/xmp/libxmp.git", branch: "master"
    depends_on "autoconf" => :build
  end

  # CC BY-NC-ND licensed set of five mods by Keith Baylis/Vim! for testing purposes
  # Mods from Mod Soul Brother: https://web.archive.org/web/20120215215707/www.mono211.com/modsoulbrother/vim.html
  resource "demo_mods" do
    url "https://files.scene.org/get:us-http/mirrors/modsoulbrother/vim/vim-best-of.zip"
    sha256 "df8fca29ba116b10485ad4908cea518e0f688850b2117b75355ed1f1db31f580"
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    pkgshare.install resource("demo_mods")
  end

  test do
    test_mod = "#{pkgshare}/give-me-an-om.mod"
    (testpath/"libxmp_test.c").write <<~EOS
      #include <stdio.h>
      #include "xmp.h"

      int main(int argc, char** argv)
      {
          char* mod = argv[1];
          xmp_context context;
          struct xmp_module_info mi;

          context = xmp_create_context();
          if (xmp_load_module(context, mod) != 0) {
              puts("libxmp failed to open module!");
              return 1;
          }

          xmp_get_module_info(context, &mi);
          puts(mi.mod->name);
          return 0;
      }
    EOS

    system ENV.cc, "libxmp_test.c", "-L#{lib}", "-lxmp", "-o", "libxmp_test"
    assert_equal "give me an om", shell_output("\"#{testpath}/libxmp_test\" #{test_mod}").chomp
  end
end
