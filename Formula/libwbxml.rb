class Libwbxml < Formula
  desc "Library and tools to parse and encode WBXML documents"
  homepage "https://sourceforge.net/projects/libwbxml/"
  url "https://downloads.sourceforge.net/project/libwbxml/libwbxml/0.11.6/libwbxml-0.11.6.tar.bz2"
  sha256 "2f5ffe6f59986b34f9032bfbf013e32cabf426e654c160d208a99dc1b6284d29"
  revision 1
  head "https://github.com/libwbxml/libwbxml.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2c363ea6c4504c817ba8d2c5b5cd8da9e261dff223bb2c0c5356c05013f55a46" => :catalina
    sha256 "90fce3d25a436373feee3fd99b19596c00bab30cdf89303018a111190896aab0" => :mojave
    sha256 "026c871094433f113060870998649acdd8dd8b863a1d21e79e1fd100d45cc287" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "wget"

  def install
    # Sandbox fix:
    # Install in Cellar & then automatically symlink into top-level Module path
    inreplace "cmake/CMakeLists.txt", "${CMAKE_ROOT}/Modules/",
                                      "#{share}/cmake/Modules"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBUILD_DOCUMENTATION=ON"
      system "make", "install"
    end
  end
end
