class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.5.5.tar.gz"
  sha256 "670883a369b5d81e0ef9e2282f4415452f0ec2b9dc885ee3fd8e2a0045f50787"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "23025fc3eb3da9957851c26a33f5dff8c3d42a75bb25f2fbcb8bf2f97a06162f" => :catalina
    sha256 "d939c899d388ee7f0e6c343b19b5bd5b9be278bb9f4f34cc3cd28043bdcaf939" => :mojave
    sha256 "76ab05b8ece67ec2625beac695109398b65131a8d916dbb2c4cf8a98e731a58a" => :high_sierra
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
