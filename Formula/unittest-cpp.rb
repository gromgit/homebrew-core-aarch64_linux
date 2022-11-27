class UnittestCpp < Formula
  desc "Unit testing framework for C++"
  homepage "https://github.com/unittest-cpp/unittest-cpp"
  license "MIT"

  stable do
    url "https://github.com/unittest-cpp/unittest-cpp/releases/download/v2.0.0/unittest-cpp-2.0.0.tar.gz"
    sha256 "1d1b118518dc200e6b87bbf3ae7bfd00a0cfc6be708255f98e5e3d627a7c9f98"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/unittest-cpp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "85b218b4ab2e1897a5271b147335a08b56ca872fe9370878a6d1e3efb19ba2d1"
  end

  head do
    url "https://github.com/unittest-cpp/unittest-cpp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_match version.to_s, File.read(lib/"pkgconfig/UnitTest++.pc")
  end
end
