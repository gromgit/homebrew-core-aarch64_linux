class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.6.1.tar.gz"
  sha256 "827437c9a684fcb88ee21a8fd8f0ecd94f36e2db213f74357d0465c5a7e72ac6"

  bottle do
    cellar :any
    sha256 "e8d0ed10a711ac67fd529950a015c1df0c522273de713a6d4cd10acf0821a569" => :catalina
    sha256 "fedb0fa752508df5c68b99140d4f14be6e5f1f06d1ea6cc3e0b23a86dfc83e3a" => :mojave
    sha256 "5c5112d0ec9c2c177ed076f4c519e87850e8b59d19decc1e91b9136f3739658c" => :high_sierra
  end

  depends_on "libomp"

  def install
    system "./configure", "--without-cuda",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <faiss/IndexFlat.h>

      int main()
      {
          faiss::IndexFlatL2 index(64);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lfaiss", "test.cpp", "-o", "test"
    system "./test"
  end
end
