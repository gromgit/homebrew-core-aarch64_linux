class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.4.0.tar.gz"
  sha256 "5fc457b081cdf02708436bb708940fd6b689e03fc336d3faab652f0b85592c00"
  revision 3
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "2b5fa37108eca0585b9edcf7e5d2e74d2dcd481846bb69dfef551ccfbf0c67f5" => :catalina
    sha256 "800ec6f9d58e05a6836db8b0b49ec2c810b213e394db498d313f954df0fb3868" => :mojave
    sha256 "85b930dac122e79485e5dc8705a6b01d4fa6c7646cad14361e740c5d262f545d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gst-plugins-good"
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    system "cmake", ".", "-DMOVIES=on", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/pdfpc", "--version"
  end
end
