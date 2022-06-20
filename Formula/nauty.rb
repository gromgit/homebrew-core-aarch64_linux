class Nauty < Formula
  desc "Automorphism groups of graphs and digraphs"
  homepage "https://pallini.di.uniroma1.it/"
  url "https://pallini.di.uniroma1.it/nauty27r3.tar.gz"
  version "2.7r3"
  sha256 "4f0665b716a53f7a14ea2ae30059f23d064ce3fe4c12c013404ef6e1ee0b88c2"
  version_scheme 1

  livecheck do
    url :homepage
    regex(/Current\s+?version:\s*?v?(\d+(?:\.\d+)+(?:r\d+)?)/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("R", "r") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nauty"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f96713646bfa3c180eef0d8783d88d4373c288b003838f35e1f875bbaf1f9802"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"

    bin.install %w[
      NRswitchg addedgeg amtog assembleg biplabg catg complg converseg
      copyg countg cubhamg deledgeg delptg directg dreadnaut dretodot
      dretog edgetransg genbg genbgL geng gengL genquarticg genrang
      genspecialg gentourng gentreeg hamheuristic labelg linegraphg
      listg multig newedgeg pickg planarg ranlabg shortg showg
      subdivideg twohamg underlyingg vcolg watercluster2
    ]

    (include/"nauty").install Dir["*.h"]

    lib.install "nauty.a" => "libnauty.a"

    doc.install "nug27.pdf", "README", Dir["*.txt"]

    # Ancillary source files listed in README
    pkgshare.install %w[sumlines.c sorttemplates.c bliss2dre.c blisstog.c poptest.c dretodot.c]
  end

  test do
    # from ./runalltests
    out1 = shell_output("#{bin}/geng -ud1D7t 11 2>&1")
    out2 = pipe_output("#{bin}/countg --nedDr -q", shell_output("#{bin}/genrang -r3 114 100"))

    assert_match "92779 graphs generated", out1
    assert_match "100 graphs : n=114; e=171; mindeg=3; maxdeg=3; regular", out2

    # test that the library is installed and linkable-against
    (testpath/"test.c").write <<~EOS
      #define MAXN 1000
      #include <nauty.h>

      int main()
      {
        int n = 12345;
        int m = SETWORDSNEEDED(n);
        nauty_check(WORDSIZE, m, n, NAUTYVERSIONID);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/nauty", "-L#{lib}", "-lnauty", "-o", "test"
    system "./test"
  end
end
