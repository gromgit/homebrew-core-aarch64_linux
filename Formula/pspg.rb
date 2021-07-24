class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.1.3.tar.gz"
  sha256 "df53ab6e7fa47d32ff2bad89d012ed610336c4586f3ffe417134c8d6af3fb9b7"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fdc5ad11d57af1bd9d4a6b620573564291d9c900947b41c1e26ed52b186308eb"
    sha256 cellar: :any,                 big_sur:       "0c538a2a5bebb7546096d6c8cf145b1f6b9974c71991303dbb3363dbe2e383f4"
    sha256 cellar: :any,                 catalina:      "187114412713f9d2d0d2e4323ed785fcf845d8d27d622ab5a2bcde466ed36059"
    sha256 cellar: :any,                 mojave:        "5a5a8debcf4ae4e4e3525260bc78457efd7129b7807addfce737eef70c7f551e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a353c893192d5a9d76c1c62d1d789e358ca4333e22a331b04d3ebe43981bb2b8"
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
