class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.65/asymptote-2.65.src.tgz"
  sha256 "15e3d71a0c492c9f2142dd86a7390bcbf59c944ec8b86970833599ff37c59844"

  bottle do
    sha256 "f9533fe2de225a68b658fe63e382ee52e335875cfbddf7b7ca641ad226615338" => :catalina
    sha256 "1c2ccd8c1686f5af101412ac87f81213d7294f2f97e0939307af52aa870a2b37" => :mojave
    sha256 "164c6a5ed383dbd4c7ceee488ebc1623e65faefcba8090a6a07619c8f8488eb4" => :high_sierra
  end

  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "glm"
  depends_on "gsl"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.65/asymptote.pdf"
    sha256 "9a3aafacab8e09ca677972321d04c3fe9a335adad960e5f22ab30ab5fb82b705"
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF
    system "#{bin}/asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
