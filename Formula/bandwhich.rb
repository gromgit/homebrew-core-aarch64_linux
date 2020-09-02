class Bandwhich < Formula
  desc "Terminal bandwidth utilization tool"
  homepage "https://github.com/imsnif/bandwhich"
  url "https://github.com/imsnif/bandwhich/archive/0.17.0.tar.gz"
  sha256 "9bcde0e10d0a601105d89fa808c0ee2c7880de40877619ae5350b9e2c9e4f343"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "682f1c186b11e833d70994a013e8b80cda4b642ea46a8a3e05b8bbc9b8924aed" => :catalina
    sha256 "7139d8018a92ba27976d8bba7207bd19f221b90780c15c41eba1857f2d65cf3f" => :mojave
    sha256 "6dc8522efbc24509a80e5065dccae84da0bd5494506686e40fac663b197199b0" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/bandwhich --interface bandwhich", 2
    assert_match output, "Error: Cannot find interface bandwhich"
  end
end
