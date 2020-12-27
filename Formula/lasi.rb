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
    sha256 "e00c7b114025b62a0666b5fe26603b48b4a2592f4e11c1cba044bf9b2ffc913f" => :big_sur
    sha256 "2c29f3bef5230641352714e4dee8bca0278f45bd22928c1908b696821d5b8261" => :catalina
    sha256 "fa986f8628b3e9914b46ab430d1f8105d1e83e70857c5e41e69c1fa022c16064" => :mojave
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
