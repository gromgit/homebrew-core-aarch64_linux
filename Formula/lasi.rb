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
    sha256 "22d0d200afeb592551609f12b77d26a532502cbec97a6b0a3fb4c54acbba3f36" => :big_sur
    sha256 "a6d2a0c09ea3c6f89263ce136bde19a078588548f910fdaabdbb2dd8f832e687" => :arm64_big_sur
    sha256 "282b6012525bc11ab257277235ebf1ced48d64963c4910f04a9e7fb2648cdf20" => :catalina
    sha256 "33c0dd6299bcd02402480ffef6a72d6bf9134b612bd52f9ff9c310e9063ab006" => :mojave
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

    system "cmake", ".", *args

    system "make", "install"
  end
end
