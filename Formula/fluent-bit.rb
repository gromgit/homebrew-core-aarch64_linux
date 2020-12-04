class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.6.8.tar.gz"
  sha256 "214c800d8f1f0cd74cdc772775481e054546228194b4e49b50fe36e924b6ea03"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "46f9ae87f85050a5d06fcff1de61b3c0d15c474bf9982be445c7a69b2646a4a6" => :big_sur
    sha256 "23b7edbccc399509d788a31b65bd5c474a494f0fcd3ad999893927660dd207ca" => :catalina
    sha256 "1c856a15e99fa55a985711aa7f3d8ac367d53716c261bc94f63dc6064d06c876" => :mojave
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
