class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  # new canonical url (for newer versions): http://mirrors.ctan.org/web/noweb.zip
  url "https://deb.debian.org/debian/pool/main/n/noweb/noweb_2.11b.orig.tar.gz"
  sha256 "c913f26c1edb37e331c747619835b4cade000b54e459bb08f4d38899ab690d82"
  license "Noweb"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/noweb"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ca67122cdebb9c331a0ff56393d3c3e2232d8470e0b42c41b2d1e457ee391ea9"
  end

  depends_on "icon"

  def texpath
    prefix/"tex/generic/noweb"
  end

  def install
    cd "src" do
      system "bash", "awkname", "awk"
      system "make", "LIBSRC=icon", "ICONC=icont", "CFLAGS=-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=1"

      bin.mkpath
      lib.mkpath
      man.mkpath
      texpath.mkpath

      system "make", "install", "BIN=#{bin}",
                                "LIB=#{lib}",
                                "MAN=#{man}",
                                "TEXINPUTS=#{texpath}"
      cd "icon" do
        system "make", "install", "BIN=#{bin}",
                                  "LIB=#{lib}",
                                  "MAN=#{man}",
                                  "TEXINPUTS=#{texpath}"
      end
    end
  end

  def caveats
    <<~EOS
      TeX support files are installed in the directory:

        #{texpath}

      You may need to add the directory to TEXINPUTS to run noweb properly.
    EOS
  end

  test do
    (testpath/"test.nw").write <<~EOS
      \section{Hello world}

      Today I awoke and decided to write
      some code, so I started to write Hello World in \textsf C.

      <<hello.c>>=
      /*
        <<license>>
      */
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Hello World!\n");
        return 0;
      }
      @
      \noindent \ldots then I did the same in PHP.

      <<hello.php>>=
      <?php
        /*
        <<license>>
        */
        echo "Hello world!\n";
      ?>
      @
      \section{License}
      Later the same day some lawyer reminded me about licenses.
      So, here it is:

      <<license>>=
      This work is placed in the public domain.
    EOS
    assert_match "this file was generated automatically by noweave",
                 pipe_output("#{bin}/htmltoc", shell_output("#{bin}/noweave -filter l2h -index -html test.nw"))
  end
end
