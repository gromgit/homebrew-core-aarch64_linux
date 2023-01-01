class Latex2rtf < Formula
  desc "Translate LaTeX to RTF"
  homepage "https://latex2rtf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/latex2rtf/latex2rtf-unix/2.3.18/latex2rtf-2.3.18a.tar.gz"
  sha256 "338ba2e83360f41ded96a0ceb132db9beaaf15018b36101be2bae8bb239017d9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/latex2rtf/files/latex2rtf-unix/[^/]+/latex2rtf[._-](\d+(?:[.-]\d+)+[a-z]?)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/latex2rtf"
    sha256 aarch64_linux: "6fbcb7184e195c68b97549f0766c11bd6c86a81f1cc7558e858ae8111b10009b"
  end

  def install
    inreplace "Makefile", "cp -p doc/latex2rtf.html $(DESTDIR)$(SUPPORTDIR)",
                          "cp -p doc/web/* $(DESTDIR)$(SUPPORTDIR)"
    system "make", "DESTDIR=",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "INFODIR=#{info}",
                   "SUPPORTDIR=#{pkgshare}",
                   "CFGDIR=#{pkgshare}/cfg",
                   "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{LaTeX to RTF}
      \\begin{document}
      \\maketitle
      \\end{document}
    EOS
    system bin/"latex2rtf", "test.tex"
    assert_predicate testpath/"test.rtf", :exist?
    assert_match "LaTeX to RTF", File.read(testpath/"test.rtf")
  end
end
