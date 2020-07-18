class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.5.1.tar.gz"
  sha256 "c3daec42a54adf441d70923374f1b003aa987d544346949e9a0b6a59490ffd7f"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "5653d8b9c1e0f42499448c0af264c93bc37293c89d5f2d641e2c29f32f427a46" => :catalina
    sha256 "3c9abd009fec7c0923a9e01ac7773c61ab9c7182f115e14a886e5f1013237717" => :mojave
    sha256 "acd62cb69ab4b758c3ab7f6142bd6af7de0f3654bef45d38e1915c3b42fa5f3a" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
