class PariSeadataBig < Formula
  desc "Additional modular polynomial data for PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  url "https://pari.math.u-bordeaux.fr/pub/pari/packages/seadata-big.tar"
  # Refer to http://pari.math.u-bordeaux.fr/packages.html#packages for most recent package date
  version "20170418"
  sha256 "7c4db2624808a5bbd2ba00f8b644a439f0508532efd680a247610fdd5822a5f2"
  license "GPL-2.0-or-later"

  depends_on "pari"
  depends_on "pari-seadata"

  def install
    (share/"pari/seadata").install Dir["#{buildpath}/seadata/sea*"]
    doc.install "seadata/README.big" => "README"
  end

  test do
    term = "-812742150726123010437180630597083*y^19"
    output = pipe_output(Formula["pari"].opt_bin/"gp -q", "ellmodulareqn(503)").chomp
    assert_match term, output
  end
end
