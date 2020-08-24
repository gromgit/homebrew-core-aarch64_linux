class LibtorrentRasterbar < Formula
  desc "C++ bittorrent library with Python bindings"
  homepage "https://www.libtorrent.org/"
  url "https://github.com/arvidn/libtorrent/releases/download/libtorrent-1.2.9/libtorrent-rasterbar-1.2.9.tar.gz"
  sha256 "6c986225a1c2d9eb23c5b1ac0692d83208b721a05c968102a17ee3fde01bd709"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "52c7e505deb13609c05976b221cc5a143ea0cc7b9de3e540f9c9b85340a1a2a0" => :catalina
    sha256 "8b1665c63ef8651ab5b9c3ef459819f1feb76bd39932c60c3663195709997184" => :mojave
    sha256 "a29169879ed8a8ddb618fed9e794babb14cf52344f51edc777381ddf899498b9" => :high_sierra
  end

  head do
    url "https://github.com/arvidn/libtorrent.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  conflicts_with "libtorrent-rakshasa", because: "they both use the same libname"

  def install
    pyver = Language::Python.major_minor_version(Formula["python@3.8"].bin/"python3").to_s.delete(".")
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-encryption
      --enable-python-binding
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-boost-python=boost_python#{pyver}-mt
      PYTHON=python3
      PYTHON_EXTRA_LIBS=#{`#{Formula["python@3.8"].opt_bin}/python3-config --libs --embed`.chomp}
      PYTHON_EXTRA_LDFLAGS=#{`#{Formula["python@3.8"].opt_bin}/python3-config --ldflags`.chomp}
    ]

    if build.head?
      system "./bootstrap.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"

    rm Dir["examples/Makefile*"]
    libexec.install "examples"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{Formula["boost"].include}/boost",
                    "-L#{lib}", "-ltorrent-rasterbar",
                    "-L#{Formula["boost"].lib}", "-lboost_system",
                    "-framework", "SystemConfiguration",
                    "-framework", "CoreFoundation",
                    libexec/"examples/make_torrent.cpp", "-o", "test"
    system "./test", test_fixtures("test.mp3"), "-o", "test.torrent"
    assert_predicate testpath/"test.torrent", :exist?
  end
end
