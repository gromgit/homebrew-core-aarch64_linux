class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.0.1.tar.gz"
  sha256 "428b61075cfe313071bb59ccd07736dae07244a065c2001662c9c3d3988ab349"

  bottle do
    cellar :any
    sha256 "ad8926ac577b4adb2ce1cce23769e3a3d31027ed7264c99aa42099e238525fe4" => :catalina
    sha256 "3ffb80af12a8fd92b03292a375a3ca30c24ae61281b1dd81e5022fe363e39b8f" => :mojave
    sha256 "c0fed1980b3e977ab565b6bea93d885c3a697881d20ecd812640f3d0a869b6d2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ntl"

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/BGV_database_lookup/BGV_database_lookup.cpp", testpath/"test.cpp"
    mkdir "build"
    system ENV.cxx, "-std=c++14", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-lhelib", "-lntl", "test.cpp", "-o", "build/BGV_database_lookup"

    cp pkgshare/"examples/BGV_database_lookup/runtest.sh", testpath/"runtest.sh"
    system "./runtest.sh"
  end
end
