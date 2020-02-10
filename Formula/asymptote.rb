class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  url "https://downloads.sourceforge.net/project/asymptote/2.62/asymptote-2.62.src.tgz"
  sha256 "60b085316b65af6a0e5132a8451c13b642cfe91c9096dc35d43b7b77a9dd2014"

  bottle do
    sha256 "64b808892251efca9174dedbca7c7053771d5f6ea84777562a6a92275ba1b50f" => :catalina
    sha256 "ee051fe8dd1b6162d5686c0a0f8a0fc9dd6268c7befc72952721f6f6ab5f7413" => :mojave
    sha256 "cc10a84f49fd48428e79d8f5792335c5b4f4dcf51be79c1a013f946321c7e82d" => :high_sierra
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
