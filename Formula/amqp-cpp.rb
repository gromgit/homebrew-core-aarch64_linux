class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.15.tar.gz"
  sha256 "21e6ae69dcf535cd1be49b272c3ff019134dddc7d812c0050e5d7bf4e19d0c3b"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c464e68f11d1ce2c3d96aca7833c473d9dc708f417064bf0f8118c55eaa0fbcd"
    sha256 cellar: :any_skip_relocation, big_sur:       "a91e81891937789703c6a4cb22536dcaeb0a8e933e0ca20a8db32067dd919bf4"
    sha256 cellar: :any_skip_relocation, catalina:      "010b745ff538b044ecb43bd0bb18e1cbe374589e4bc4ca45b906eee52138c34f"
    sha256 cellar: :any_skip_relocation, mojave:        "c1d2d2a4a73a08ad98cfdaa6d08d581398780481a74ecc928a5e7aa356d25ac1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ece40b3b1174cd90632f48759a931c515f79267330c9578c03889eb6fb60c5d"
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
                    "test", "-lamqpcpp"
    system "./test"
  end
end
