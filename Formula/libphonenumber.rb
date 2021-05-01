class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.22.tar.gz"
  sha256 "52ecf9d9fd0a95bdc854e3d39c68c78da7b823c6e3d28cb52fcbd04dee929680"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e3d9335e3ac0d0f998eb41973e495eb80f8f2d54d2eeb576d172951f2c36cd7b"
    sha256 cellar: :any, big_sur:       "a13487ac590bc2e22917d97f3b1451cf95b8a6704ac347879522b1bf3f5cc3e9"
    sha256 cellar: :any, catalina:      "8f9ebca510d78d9e1deec7e6fe065bcb01ab2a36629dfc33df49ed87de93c839"
    sha256 cellar: :any, mojave:        "c5f34b23fbba36db70dd16cf49dd7195632fc9041976ce462bc3805e9ca6a644"
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
