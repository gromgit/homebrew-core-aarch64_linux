class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.15.tar.xz"
  sha256 "778486fb460f44e8e242569ab589e7e341f6d166b521704aa9bd07f95ae77233"
  head "https://github.com/dreibh/subnetcalc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8174139a132554a6c03283490e183b5fbd10949e1a0b0b723f6486781272c4df" => :catalina
    sha256 "84c8dc962b21ef45b9b9d67359634b8c2d39b820c8c7c63e03c96f28fa8e47ec" => :mojave
    sha256 "b7c21b1e1d70a0701673ca99b6bd0c6ce9e4a93a0df9db9dc356e0be9e6900fa" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
