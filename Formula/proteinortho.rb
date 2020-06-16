class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.17/proteinortho-v6.0.17.tar.gz"
  sha256 "b9ed0cf30342952fa6f44eb96103074c8122bebae90b4a311f3edd97f9279053"

  bottle do
    cellar :any
    sha256 "566a8f9d0ed9363380d69142b11c053687d502472445c8355788b77456855efc" => :catalina
    sha256 "9c286d9ee4fba3275ab9ef6c8578e77fd30131ba1bf262e424e93e20450fc81a" => :mojave
    sha256 "9524f1b15a90d1c16ed2a6239b22be8a8511d2ef61fb7d51ddd9a83b82fac2f3" => :high_sierra
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
