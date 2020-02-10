class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.62/asymptote-2.62.src.tgz"
  sha256 "60b085316b65af6a0e5132a8451c13b642cfe91c9096dc35d43b7b77a9dd2014"

  bottle do
    sha256 "d1c5cca626e41ea4c04d5b1e8e04baf6d4cf79202e6327bb27fa9e6569b3b63c" => :catalina
    sha256 "ac4d02d92dde24f3fb1e402dbb42ab477c903aed005c3a6fa0b675fb758b8f90" => :mojave
    sha256 "4afce4c3e36e038e9a241338300dec90955faefbc3e77828f860d28537b06999" => :high_sierra
  end

  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "glm"
  depends_on "gsl"

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.62/asymptote.pdf"
    sha256 "afd22e35f984a6187ea4064f217dc167ff897864db23b825d4cbd78cd7114710"
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
