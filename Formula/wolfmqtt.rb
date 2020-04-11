class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT.git",
      :tag      => "v1.4",
      :revision => "af3d2926773b2c97f5e3a86ea2562e339a91b747"
  head "https://github.com/wolfSSL/wolfMQTT.git"

  bottle do
    cellar :any
    sha256 "bd879bda38386592a87d1672c7cb5af944cd6290cff62a1249cfc8ad095a0cd3" => :catalina
    sha256 "01cf2379343cd396f3bfa3136732a4861cdc7454fe30e0e201153d08453d8c4c" => :mojave
    sha256 "0ea25c4930469b196fd97e76ef1b4b0e9977dccb9a7147d7f457e1604b7b54d9" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wolfssl"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-nonblock
      --enable-mt
      --enable-mqtt5
      --enable-propcb
      --enable-sn
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOT
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    EOT
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end
