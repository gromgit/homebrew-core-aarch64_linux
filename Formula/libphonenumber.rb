class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.33.tar.gz"
  sha256 "4901487b9c5c4a59e1601ceb2987dc7c336abab4c70284dbedb0c0f6faa1f0ca"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "60921246b9d6a8482a86806230efeeffac6fc082f6c743fb63463c7f06dbdb7c"
    sha256 cellar: :any,                 big_sur:       "8e5b76fe95ef7185c9bea5f73eefadb6f5a6251f7d5947670b2e0fb3dac052fe"
    sha256 cellar: :any,                 catalina:      "f38bd8cb7bb4d0d095e96991f5683ab0b4f68971113828f70dcdc66a8f0cdab0"
    sha256 cellar: :any,                 mojave:        "b24d45001372c8ca1c143e86bf0792340f1ca645427a3d88282be73e50974ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3141288945703b3c3ccacdc3d0aed50b960773ab596028aa55911dd4bd978f48"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  def install
    ENV.cxx11
    system "cmake", "cpp", "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].include}",
                           *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
