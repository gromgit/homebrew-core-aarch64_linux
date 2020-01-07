class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.12/proteinortho-v6.0.12.tar.gz"
  sha256 "36fcec0891c8bf451349122e7b2783b1ec6aaf195c32139bc78e7201ab00b8c1"

  bottle do
    cellar :any
    sha256 "9bd90ecd679b2d7359ebfee1ec8a976b04bdee7efd7b06914a879361599f14ff" => :catalina
    sha256 "af1f1368c59e1b3a9be9cb6c2993d855b4e8759066043cdfc66808083d24cdda" => :mojave
    sha256 "8e9c2960879c33caef01fcd405081867b08f55c8b92b5c20d719b1c694a80c50" => :high_sierra
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
