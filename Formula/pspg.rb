class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/3.1.3.tar.gz"
  sha256 "2f4d1660a150c988c3b1d126a24fe8cb0f76471a829806dacb3ed85fe0e45c8d"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "202cd5e760ac8dd0944678d576466f3663af59d071d22f5deee8a9beb12a5bdd" => :catalina
    sha256 "739a146032e27e1c98ff06e51b26ef237319220d63319145fdc28109b57c1783" => :mojave
    sha256 "5a12bd07ee31870e60e5d8f607ab5062e969a5914f88c8727013cea7cdee8c5c" => :high_sierra
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
