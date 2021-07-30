class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.3.1.tar.gz"
  sha256 "496e1f568e346ebd62d9a62a32691cd975d36311e3bb15dc347d14e7b2cd6c67"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "70cd41e31ab4b1b11e8178654d59627cec008742e7aa991f3357fb33eef49e14"
    sha256 cellar: :any,                 big_sur:       "77e75491998cb5a512a792b1858f8c83501a5ee263aae5e778dcc9d59f04bf99"
    sha256 cellar: :any,                 catalina:      "3c53d545abcec6b84005550f22ae49fd30e651d53dc447e65641b41815983375"
    sha256 cellar: :any,                 mojave:        "2cfd6be0f603221017b4e8568ed50294cc348070ee42eabfa3158eee11650242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de22e11b512a3b6797f9bade2bcda89620c121dd724cef85e0ef06b7ba8a4a68"
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
