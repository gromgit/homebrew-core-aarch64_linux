class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj.org/"
  url "https://github.com/OSGeo/PROJ/releases/download/7.0.0/proj-7.0.0.tar.gz"
  sha256 "ee0e14c1bd2f9429b1a28999240304c0342ed739ebaea3d4ff44c585b1097be8"

  bottle do
    rebuild 1
    sha256 "3d45e9a534f97ed67183252e41c8d5c713e2f9f9d29df26bd1f31043d4b32731" => :catalina
    sha256 "de1ce33e57ad23e36c5ad5bc3c902630870b9a63b1b21d819d8853881736bf7f" => :mojave
    sha256 "719b1670cf4560071cfb64b811ef494b278655f33e00b221eeda6f209d2ba6e7" => :high_sierra
  end

  head do
    url "https://github.com/OSGeo/proj.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtiff"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  conflicts_with "blast", :because => "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "https://download.osgeo.org/proj/proj-datumgrid-1.8.zip"
    sha256 "b9838ae7e5f27ee732fb0bfed618f85b36e8bb56d7afb287d506338e9f33861e"
  end

  # Fixes https://github.com/OSGeo/PROJ/issues/2064 using https://github.com/OSGeo/PROJ/pull/2067
  # Remove after version > 7.0.0
  patch do
    url "https://github.com/OSGeo/PROJ/commit/d8835f1288207ba9a7e78082050ef61af3ded1e3.diff?full_index=1"
    sha256 "9a579a7a0fa33ea8c03639aef95f2b1d22afbc1d5167a927ce0670ff5432719e"
  end

  def install
    (buildpath/"nad").install resource("datumgrid")
    # we need to touch these files to stop autoreconf running and then failing due to the patch op above
    # Remove touch op after version > 7.0.0
    touch ["configure.ac", "aclocal.m4", "configure", "Makefile.am", "Makefile.in", "src/proj_config.h.in"]
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS

    output = shell_output("#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test")
    assert_equal match, output
  end
end
