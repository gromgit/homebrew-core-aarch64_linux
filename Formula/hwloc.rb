class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://www.open-mpi.org/software/hwloc/v2.2/downloads/hwloc-2.2.0.tar.bz2"
  sha256 "ae70b893df272b84afd7068d351aae5c8c4fd79d40ca783b3e67554b873a2252"

  bottle do
    cellar :any
    sha256 "94e4e238c45da330b53fde9c622e74a2dfabd00a17f37fa1807b1d828452759d" => :catalina
    sha256 "df6180858171e5345d517cb5d7bace1f0f33fd63a84180ec591f2530465d7172" => :mojave
    sha256 "e07953afc5a1e9548c467b1336c7003c2e2d008110c8e2012f160dedc3b15037" => :high_sierra
  end

  head do
    url "https://github.com/open-mpi/hwloc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"
  end

  test do
    system ENV.cc, pkgshare/"tests/hwloc/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
