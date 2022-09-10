class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.7/libtorrent-rasterbar-2.0.7.tar.gz"
  sha256 "3850a27aacb79fcc4d352c1f02a7a59e0e8322afdaa1f5d58d676c02edfcfa36"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba47a519f0e597a0509816dda47a9ee705d8c6aeb2c10b5d4b9a3babf516ea54"
    sha256 cellar: :any,                 arm64_big_sur:  "6ef64cb09622bdebf448916803ae822ec96eda79219f70fa000864f6d1c82087"
    sha256 cellar: :any,                 monterey:       "394d16660f62e75f2b7c3484e7b1f0d93d5e8472a01c5b24ee0883a8c8741374"
    sha256 cellar: :any,                 big_sur:        "f13afb140dd550e0c32edb9572eea363138db23204eea75482360d057041fe83"
    sha256 cellar: :any,                 catalina:       "f1db94dcb3d64c3be8dfa9fad63aaca91e034e74a3042a36d7022ee89501e505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c31bf118a60d52127cb93855a1977cd637f87e184754e3471b4ef3dbe230692"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
      -DCMAKE_INSTALL_RPATH=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "examples"
  end

  test do
    args = [
      "-I#{Formula["boost"].include}/boost",
      "-L#{Formula["boost"].lib}",
      "-I#{include}",
      "-L#{lib}",
      "-lpthread",
      "-lboost_system",
      "-ltorrent-rasterbar",
    ]

    if OS.mac?
      args += [
        "-framework",
        "SystemConfiguration",
        "-framework",
        "CoreFoundation",
      ]
    end

    system ENV.cxx, libexec/"examples/make_torrent.cpp",
                    "-std=c++14", *args, "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
