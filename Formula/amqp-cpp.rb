class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.2.1.tar.gz"
  sha256 "33306d6cdb60554998afb304cdc3e3120a71ea539b4be187812065b1b9e59c2f"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git"

  livecheck do
    url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "15df92065416d411450b85a4851ea786249e9635639dc2d29d795edec822e993" => :catalina
    sha256 "61c0434f7cdddd55d11e1ce54b6b6528abe69c6ee2dbbae711b0b5eeb4743589" => :mojave
    sha256 "ab0fc04ce7edca0225f79bdcf89a228e67c2efe9247b883d0ee6fe3ffbe98f88" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    system "cmake", "-DBUILD_SHARED=ON",
                    "-DCMAKE_MACOSX_RPATH=1",
                    "-DAMQP-CPP_LINUX_TCP=ON",
                    *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-o",
                    "test", "-lc++", "-lamqpcpp"
    system "./test"
  end
end
