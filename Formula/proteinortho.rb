class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.14/proteinortho-v6.0.14.tar.gz"
  sha256 "b7653d3b5f71331154625c3d4a62a1ebaf1fa24c77f4e2f3f99fc8c08fe3c743"

  bottle do
    cellar :any
    sha256 "5d79fb2e746542350513d67eaa3d747f6c6e09d86cd2c6dfc3465b38f35e4267" => :catalina
    sha256 "7a76cfd6bd99fc9dc43251c9a263984699dda21ecef5fbb41e09a33c337118ee" => :mojave
    sha256 "ce909b9a126d82f41caa268251cbd7f103185dedcc1369d239fd872112eae188" => :high_sierra
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
