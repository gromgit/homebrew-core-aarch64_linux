class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 3
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1efc3a134820a81981068c8f99f519c96e13604e6fd1d9acb7501a0f888a660d"
    sha256 cellar: :any,                 arm64_big_sur:  "0fdfea8c88d7ec12183a6377c0b8bd78d2f9f6c6e7f62fd6e274289b5b20a9ac"
    sha256 cellar: :any,                 monterey:       "a49348936a6c08fbcfaec0816ad52ac36fccd7d37c1f9df2c43a6c4d5f74801a"
    sha256 cellar: :any,                 big_sur:        "94ff05f451b5556620319fe52f59ce091cac762ea42bf7c701048870985afbe8"
    sha256 cellar: :any,                 catalina:       "43a06e0d576f4754e730dc215d38a092924e08bb9325f6085c854963f65c3e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c478ea6722862268c26f3601b2de3e759743c3975c58051a84e6ac1a9e0b36"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
