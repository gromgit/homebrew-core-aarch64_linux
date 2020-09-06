class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.4.tar.gz"
  sha256 "0dd4ddf3c4f5faff2c9e7285d72d31d41130e73a984cee4f3a6cbc65f42942ef"
  license "BSD-3-Clause"

  livecheck do
    url "https://github.com/nco/nco/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "bab1f5fe6df7ba6cc8fc3898bd69d533f8de6549594f63a750cb64ae322e760b" => :catalina
    sha256 "2a9ff992e98765074901e8b8b9a2dbe839e33de30712df3a8c90fbd397c658f0" => :mojave
    sha256 "e9f00b7d4927dc1c9a16f0120173746d9063c3251d01416a20fd517d07aa724b" => :high_sierra
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
