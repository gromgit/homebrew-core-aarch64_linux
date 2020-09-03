class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp/archive/1.8.40.tar.gz"
  sha256 "1e95f2812d19d77ba361301a5a277b91baa4782aa797311b738c8b9fa1f5e252"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    sha256 "d53b34c3ca0d6223775ef8894a4820293d7c3a5b3e1b3df42ebbdca0c6001f52" => :catalina
    sha256 "485827a010be548030399c5416559fbc1c27693b97f33cd54a16448f1fa2a926" => :mojave
    sha256 "2a290af6f99a77e48e6948715823ba9676e67aff1893705e3c02d9ce6ff0cbeb" => :high_sierra
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
