class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.4.tar.bz2"
  sha256 "ec36fb49080f834690c24008328a5ef42d3cf584ef4060f3a35aa4681cb31b74"
  revision 2

  bottle do
    cellar :any
    sha256 "37e829f5dfd5bb27398ed4c2744b6ce35f8338b0e4994d4981b3e6a915b80872" => :catalina
    sha256 "1ab6dc2e9827ee83b319996ab3e90d10b4dbeb8b474ef06649832b00b857223a" => :mojave
    sha256 "111b0b0e9798795eebe44154610bfe022b288c2461a63d8c7f1656c148eba568" => :high_sierra
    sha256 "f4e880f83165a30696f49be0915ff22dbd1b27f1c04a903f9bcec49b9985c4c4" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "libusb"

  def install
    mkdir "libftdi-build" do
      system "cmake", "..", "-DPYTHON_BINDINGS=OFF",
                            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                            *std_cmake_args
      system "make", "install"
      pkgshare.install "../examples"
      (pkgshare/"examples/bin").install Dir["examples/*"] \
                                        - Dir["examples/{CMake*,Makefile,*.cmake}"]
    end
  end

  test do
    system pkgshare/"examples/bin/find_all"
  end
end
