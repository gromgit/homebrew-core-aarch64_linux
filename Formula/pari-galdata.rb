class PariGaldata < Formula
  desc "Galois resolvents data for PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  url "https://pari.math.u-bordeaux.fr/pub/pari/packages/galdata.tgz"
  # Refer to http://pari.math.u-bordeaux.fr/packages.html#packages for most recent package date
  version "20080411"
  sha256 "b7c1650099b24a20bdade47a85a928351c586287f0d4c73933313873e63290dd"
  license "GPL-2.0-or-later"

  depends_on "pari"

  def install
    (share/"pari/galdata").install gzip(*Dir["#{buildpath}/galdata/*"])
  end

  test do
    expected_output = "[16, -1, 8, \"2D_8(8)=[D(4)]2\"]"
    output = pipe_output(Formula["pari"].opt_bin/"gp -q", "polgalois(x^8-2)").chomp
    assert_equal expected_output, output
  end
end
