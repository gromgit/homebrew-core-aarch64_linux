class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.4.2.tar.gz"
  sha256 "3b99a36c082a67ef6295eabd4fb3e32ab0bff7c6b0d397d6352697335f4e57eb"
  head "https://github.com/edenhill/librdkafka.git"

  bottle do
    cellar :any
    sha256 "b32a8f71a1726357998eee485abceb7f83b0bf120d76bd028d020eee80b7c800" => :catalina
    sha256 "ce53eb8516e238160d60613f457faf1f20749ad508c7db70f5d67a35c1cb6a7b" => :mojave
    sha256 "c049841d8be6edc7d95769cdf3b645fc6036b4276a34bd51ffab3fe070d68de4" => :high_sierra
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
