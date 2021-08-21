class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/v2.0.4/libtorrent-rasterbar-2.0.4.tar.gz"
  sha256 "55bcce16c4b85b8cccd20e7ff4a9fde92db66333a25d6504a83c0bb0a5f7f529"
  license "BSD-3-Clause"
  head "https://github.com/arvidn/libtorrent.git", branch: "RC_2_0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "566168949b3c30d457469e9e1a6ee366aef3e8a3f72191b36cfcd87033834b28"
    sha256 cellar: :any,                 big_sur:       "92d140b497497ac2edc980534ff710ff50b99e967c2a01fe0c952c51a0bf3aeb"
    sha256 cellar: :any,                 catalina:      "2b5460c509171200053dbb6d0eb45b71737695239beff530d63c55265c89fec5"
    sha256 cellar: :any,                 mojave:        "593dae5994fb2e71c44f0150196d8cb719872b15e6212a8d669b1ed43c4f8f90"
    sha256 cellar: :any,                 high_sierra:   "9f140786725e1a24971d5d3a99ff77cb35ec713f6fb6fd871b40633d4a322ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1827bbb007b0675d1a1848d608c8b25efaab6674938309e6c89b78a33bfb1708"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=14
      -Dencryption=ON
      -Dpython-bindings=ON
      -Dpython-egg-info=ON
    ]
    args += std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

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

    on_macos do
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
