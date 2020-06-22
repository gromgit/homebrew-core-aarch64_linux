class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.4.4.tar.gz"
  sha256 "0984ffbe17b9e04599fb9eceb16cfa189f525a042bef02474cd1bbfe1ea68416"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    sha256 "5090a19995c88d0ce00d2bced83b33cb6f944cf91d9fd9fa1a8f22dfc470ff29" => :catalina
    sha256 "31fcd402659b9f89506c920d9fc9ae2d00141af30d80a42ca7818c6a7109a3da" => :mojave
    sha256 "ae1eb1cbe686c2b9913e87c6068db886c06ff6716a36cccfb49b9226337c89d1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        int version = rd_kafka_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
