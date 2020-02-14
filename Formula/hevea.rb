class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.33.tar.gz"
  sha256 "abface4340f80692b4f1143f15dfabc16a263902a5025933020b42638d5d2504"

  bottle do
    sha256 "56225d900e9394a1eaf18cc3ccaa7acc38b91c52afc1d089aab89101ee617064" => :catalina
    sha256 "660b2a335b60cbf727597ceac10879ff1f563d4ca07dba4ff1a0ff500ecaa8c5" => :mojave
    sha256 "c814d37b48e369ff326c4ff32dd8d4fd83e41967f28ddc5390033fdd8643f77a" => :high_sierra
  end

  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
