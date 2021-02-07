class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.2.0.tar.gz"
  sha256 "685cade90b38138fff75a9e25299d11f574d459ef070c6c939c8232b5b60a8ca"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "801343ed440433b78bc1cca7ac5545838ca33a98a5cef9875b47fd5c0938bafa"
    sha256 cellar: :any, big_sur:       "2773779aec2cbdc298567604a72a7e9646018e6c08f2ebcecd41500be4226b16"
    sha256 cellar: :any, catalina:      "5688ae4b20191421fe7cd6eccbbd978d0029b2966ee63e303c9b0456decedc56"
    sha256 cellar: :any, mojave:        "fef3018a1055283390cda9493cde113fe07cbdc34c3ae7e78aaad676f64d806b"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
