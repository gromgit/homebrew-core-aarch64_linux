class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.1.3.tar.gz"
  sha256 "2f4d1660a150c988c3b1d126a24fe8cb0f76471a829806dacb3ed85fe0e45c8d"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "6ac86e2f012a8d7e00c41097bc6b73351c6c32270a5bb32a0f6f82892303e648" => :catalina
    sha256 "b64dac55a7a70baa9d63bf605fc9a68282af547334ce0a437eac2289e2d110ea" => :mojave
    sha256 "062b5f7f8d9090b5de684b40e32bdd061fa8475351a2e60acf93f1fcd434a80c" => :high_sierra
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
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version", 1)
  end
end
