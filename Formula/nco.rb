class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.0.tar.gz"
  sha256 "2340c802808e03508a765c73e2ea69ca60eb00283c8f0fb2d4d84f86d538ab48"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "34c05780e95c154e94a35765fc8e2d8aa66b2182a94ea661330b537653291d2f"
    sha256 cellar: :any, big_sur:       "c4a9bfe70de70d54e8ce9e3feb483f4967392b314f80b108fd47d8c4de4d1bc7"
    sha256 cellar: :any, catalina:      "69e6009e8ca80dcdea7f50454bbec8e80f68a03f15aa03c87d3b0c00e8463fdf"
    sha256 cellar: :any, mojave:        "4cd7e7c1c97e015ef1e4511fecb3fc356cf2a524f0373fa762a7e0ddc525ce88"
  end

  head do
    url "https://github.com/nco/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource "example_nc" do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    testpath.install resource("example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
