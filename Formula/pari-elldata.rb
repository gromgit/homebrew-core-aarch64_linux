class PariElldata < Formula
  desc "J.E. Cremona elliptic curve data for PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  url "https://pari.math.u-bordeaux.fr/pub/pari/packages/elldata.tgz"
  # Refer to http://pari.math.u-bordeaux.fr/packages.html#packages for most recent package date
  version "20210301"
  sha256 "dd551e64932d4ab27b3f2b2d1da871c2353672fc1a74705c52e3c0de84bd0cf6"
  license "GPL-2.0-or-later"

  # The only difference in the `livecheck` blocks for pari-* formulae is the
  # package name in the regex and they should otherwise be kept in parity.
  livecheck do
    url :homepage
    regex(%r{>\s*elldata\.t[^<]+?</a>(?:[&(.;\s\w]+?(?:\),?|,))?\s*([a-z]+\s+\d{1,2},?\s+\d{4})\D}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| Date.parse(match.first)&.strftime("%Y%m%d") }
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pari-elldata"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2307c036ea5871b4e3ed04a752b59818ea44ee11188f86b36acbd466c1bd2b3e"
  end

  depends_on "pari"

  def install
    (share/"pari/elldata").install gzip(*Dir["#{buildpath}/elldata/ell*"])
    doc.install "elldata/README"
  end

  test do
    expected_output = "[0, -1, 1, -10, -20, -4, -20, -79, -21, 496, 20008, -161051, -122023936/161051, " \
                      "Vecsmall([1]), [Vecsmall([128, -1])], [0, 0, 0, 0, 0, 0, 0, 0]]"
    output = pipe_output(Formula["pari"].opt_bin/"gp -q", "ellinit(\"11a1\")").chomp
    assert_equal expected_output, output
  end
end
