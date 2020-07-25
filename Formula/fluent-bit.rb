class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.5.2.tar.gz"
  sha256 "d9dd4fe94116533cd23fc5d2e505408f687c1eb1b4c233b4f9413ff6b87d53f3"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "fd9c11da783400eea7ee1b4e4385770841f62122c9bc8a5773a7340154d4cf7c" => :catalina
    sha256 "6d759db27f15c063a2a545b42481643bd49dfeb8ae85347e6e8ac5ea1177a012" => :mojave
    sha256 "167810e67f4e2d90ca5e5b4698dcd2fb4cf3ae227b222ecf236eace13937ab27" => :high_sierra
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
