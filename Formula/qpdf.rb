class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.0.3/qpdf-10.0.3.tar.gz"
  sha256 "51e96e2e5507f52993e0cc4d04726f0614f6d6dad04eaddcb527cd3f4190a8f2"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "622b938f59652a03977c6faa6b51df6124b74ee60a610cbe5833bc8af6c26b60" => :big_sur
    sha256 "dd31dda8bb5b39fc025fc52951661a22e5ce87604393271a941151cb592837d3" => :catalina
    sha256 "34d03d5740b508c2c90db74cc1f59a17ef1dbff5d5e24c96de316bcc78fdbc1e" => :mojave
    sha256 "0e58fbc2dc0feb2d68f922ebf1885786ad4d3a89759d6bbcdf3f8319a021ac2e" => :high_sierra
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
