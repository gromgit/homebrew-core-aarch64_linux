class PariElldata < Formula
  desc "J.E. Cremona elliptic curve data for PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  url "https://pari.math.u-bordeaux.fr/pub/pari/packages/elldata.tgz"
  # Refer to http://pari.math.u-bordeaux.fr/packages.html#packages for most recent package date
  version "20210301"
  sha256 "dd551e64932d4ab27b3f2b2d1da871c2353672fc1a74705c52e3c0de84bd0cf6"
  license "GPL-2.0-or-later"

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
