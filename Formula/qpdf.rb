class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.0.2/qpdf-10.0.2.tar.gz"
  sha256 "19cd25ca241afe20006cade2c165ad3dba9a91a8354ab72ea3e02e4a60cac70d"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "9682e4525d64949414871ee286993f1df5a915c8d6e88504b13ec31fcfeb0730" => :catalina
    sha256 "630d9ceb4eb859102ddd9f1e902e71e46d574d52981de3b50c1a807c06ea393c" => :mojave
    sha256 "102c60c9f341c5ee30bb7b331f934f859eea5238208dffd5ecf21677564245d2" => :high_sierra
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
