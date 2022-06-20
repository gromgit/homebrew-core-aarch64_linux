class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.7.tar.gz"
  sha256 "818c1a2966744548935f67e899ffa41605056fb06492d959af9fa276353f0dbf"
  # See disucssions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cweb"
    sha256 aarch64_linux: "f8cbf1f289712f5adc0f48d519a70df9cd7131e6ffa75b2db6071b3600e126a2"
  end

  conflicts_with "texlive", because: "both install `cweb` binaries"

  def install
    ENV.deparallelize

    macrosdir = share/"texmf/tex/generic"
    cwebinputs = lib/"cweb"

    # make install doesn't use `mkdir -p` so this is needed
    [bin, man1, macrosdir, elisp, cwebinputs].each(&:mkpath)

    system "make", "install",
      "DESTDIR=#{bin}/",
      "MANDIR=#{man1}",
      "MANEXT=1",
      "MACROSDIR=#{macrosdir}",
      "EMACSDIR=#{elisp}",
      "CWEBINPUTS=#{cwebinputs}"
  end

  test do
    (testpath/"test.w").write <<~EOS
      @* Hello World
      This is a minimal program written in CWEB.

      @c
      #include <stdio.h>
      void main() {
          printf("Hello world!");
      }
    EOS
    system bin/"ctangle", "test.w"
    system ENV.cc, "test.c", "-o", "hello"
    assert_equal "Hello world!", pipe_output("./hello")
  end
end
