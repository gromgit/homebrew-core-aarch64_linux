class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.3.0/gmt-6.3.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.3.0-src.tar.xz"
  sha256 "69e29b62ee802a3a64260d6a1e023f1350e3bf4070221aa1307bf8a9e56c1ee5"
  license "LGPL-3.0-or-later"
  revision 4
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "0a9ed1f612777e91e061e9dd5c15c1e711ac595212acecedd925eebd81b34abb"
    sha256 arm64_big_sur:  "90bdd3828bb93f303a1b6dbff92625db5c8d009d6f630650db8c0eaab14881ad"
    sha256 monterey:       "1bde7945665681c8c7bea8c30c4cf711cc324ec491047e993be3c72434f4e10d"
    sha256 big_sur:        "07dc3765e73688bcf3c4634312ee89bcb2461a4f10bb960d88293b4836638285"
    sha256 catalina:       "9da59bfb9b59a3e6dcc2bab17354b7353b2b885cfd892b517a1bb29027927c36"
    sha256 x86_64_linux:   "aa407b0c32eb815c0e28494a7f95b0a0dcf77c2c85f0ab578e22a4c019156d53"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre2"

  resource "gshhg" do
    url "https://github.com/GenericMappingTools/gshhg-gmt/releases/download/2.3.7/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "https://github.com/GenericMappingTools/dcw-gmt/releases/download/2.1.0/dcw-gmt-2.1.0.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-2.1.0.tar.gz"
    sha256 "e810567cd474d5af9d84751938acb447a8612391ed66190d60d789974a1f9e29"
  end

  def install
    (buildpath/"gshhg").install resource("gshhg")
    (buildpath/"dcw").install resource("dcw")

    # GMT_DOCDIR and GMT_MANDIR must be relative paths
    args = std_cmake_args.concat %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DGMT_DOCDIR=share/doc/gmt
      -DGMT_MANDIR=share/man
      -DGSHHG_ROOT=#{buildpath}/gshhg
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{buildpath}/dcw
      -DCOPY_DCW:BOOL=TRUE
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DPCRE_ROOT=#{Formula["pcre2"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=FALSE
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DLICENSE_RESTRICTED:BOOL=FALSE
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
    inreplace bin/"gmt-config", Superenv.shims_path/ENV.cc, DevelopmentTools.locate(ENV.cc)
  end

  def caveats
    <<~EOS
      GMT needs Ghostscript for the 'psconvert' command to convert PostScript files
      to other formats. To use 'psconvert', please 'brew install ghostscript'.

      GMT needs FFmpeg for the 'movie' command to make movies in MP4 or WebM format.
      If you need this feature, please 'brew install ffmpeg'.

      GMT needs GraphicsMagick for the 'movie' command to make animated GIFs.
      If you need this feature, please 'brew install graphicsmagick'.
    EOS
  end

  test do
    system "#{bin}/gmt pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end
