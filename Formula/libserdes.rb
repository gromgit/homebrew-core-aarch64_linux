class Libserdes < Formula
  desc "Schema ser/deserializer lib for Avro + Confluent Schema Registry"
  homepage "https://github.com/confluentinc/libserdes"
  url "https://github.com/confluentinc/libserdes.git",
  :tag      => "v5.3.1",
  :revision => "b259d15f68dce65591700b0ccccb73311db1de3d"

  bottle do
    cellar :any
    sha256 "dead031073dab8aaef737aa375f1680292ce255831490b81fa27144541e6c5ed" => :catalina
    sha256 "a4b50f80108a872399113d393e6b51815489ae435f5c1ae50ae3fbb98cd2b438" => :mojave
    sha256 "366a4c92119d186c66c4a6366b45da2bc307084d3d183809238dcd0654e9d8d2" => :high_sierra
  end

  depends_on "avro-c"
  depends_on "librdkafka"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <signal.h>
      #include <librdkafka/rdkafka.h>
      #include <serdes-avro.h>
      #include <serdes.h>

      int main()
      {
        rd_kafka_conf_t *rk_conf;
        rk_conf = rd_kafka_conf_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libserdes", "-L/usr/local/lib/", "-L#{lib}", "-lrdkafka", "-lserdes", "-o", "test"
    system "./test"
  end
end
