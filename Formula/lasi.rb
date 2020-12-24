class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.3%20Source/libLASi-1.1.3.tar.gz"
  sha256 "5e5d2306f7d5a275949fb8f15e6d79087371e2a1caa0d8f00585029d1b47ba3b"
  license "GPL-2.0-or-later"
  revision 2
  head "https://svn.code.sf.net/p/lasi/code/trunk"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "65a46c00e8cef9b98bf1b36229a3da7cf69038b5e1d8cccbb620cb1431d27319" => :catalina
    sha256 "5ef18cc43b46bf548f42925b3b2beb4993461ba78d5078f1cacaf8ac7b7af169" => :mojave
    sha256 "447ee1c538c34cb9f06c5dc743ad86807ddb4e05ea6e345b6db085705324da6d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"

  def install
    args = std_cmake_args.dup

    # std_cmake_args tries to set CMAKE_INSTALL_LIBDIR to a prefix-relative
    # directory, but lasi's cmake scripts don't like that
    args.map! { |x| x.start_with?("-DCMAKE_INSTALL_LIBDIR=") ? "-DCMAKE_INSTALL_LIBDIR=#{lib}" : x }

    # If we build/install examples they result in shim/cellar paths in the
    # installed files.  Instead we don't build them at all.
    inreplace "CMakeLists.txt", "add_subdirectory(examples)", ""

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args

    system "make", "install"
  end
end
