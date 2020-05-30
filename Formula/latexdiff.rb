class Latexdiff < Formula
  desc "Compare and mark up LaTeX file differences"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.3.1/latexdiff-1.3.1.tar.gz"
  sha256 "2643355a4528bf6e4578741ec15af41089be0183dbc2be6799bc418491833a41"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb8350fd28f971f1aaef0835424bc396ab51fc0dafdbaed2bfb59347b231b7e9" => :catalina
    sha256 "cb8350fd28f971f1aaef0835424bc396ab51fc0dafdbaed2bfb59347b231b7e9" => :mojave
    sha256 "cb8350fd28f971f1aaef0835424bc396ab51fc0dafdbaed2bfb59347b231b7e9" => :high_sierra
  end

  # osx default perl cause compilation error
  depends_on "perl"

  def install
    bin.install %w[latexdiff-fast latexdiff-so latexdiff-vc latexrevise]
    man1.install %w[latexdiff-vc.1 latexdiff.1 latexrevise.1]
    doc.install Dir["doc/*"]
    pkgshare.install %w[contrib example]

    # Install latexdiff-so (with inlined Algorithm::Diff) as the
    # preferred version, more portable
    bin.install_symlink "latexdiff-so" => "latexdiff"
  end

  test do
    (testpath/"test1.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Hello, world.
      \\end{document}
    EOS

    (testpath/"test2.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Goodnight, moon.
      \\end{document}
    EOS

    expect = /^\\DIFdelbegin \s+
             \\DIFdel      \{ Hello,[ ]world \}
             \\DIFdelend   \s+
             \\DIFaddbegin \s+
             \\DIFadd      \{ Goodnight,[ ]moon \}
             \\DIFaddend   \s+
             \.$/x
    assert_match expect, shell_output("#{bin}/latexdiff test[12].tex")
  end
end
