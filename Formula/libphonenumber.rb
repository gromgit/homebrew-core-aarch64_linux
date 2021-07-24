class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.28.tar.gz"
  sha256 "194077e15a4c169a0d15386c63756f772546e17ecb8ea2c2fd867786cd22de93"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "6cede1dd61ec5d1bc9d73a759d418ccf00b8e4cdf574b02e46e3a60fd659fc57"
    sha256 cellar: :any,                 big_sur:       "17e9cce7894b23045fd4d6de35b0a9c5cfb7cce15789ac5f12c6f9bea2533bdf"
    sha256 cellar: :any,                 catalina:      "27cac582549d1e939f4293b887926678e166b744fcc6ed177c38137d4bd76262"
    sha256 cellar: :any,                 mojave:        "d880a469075be587378c2e14ecdcc4328e0220737543f65ead28b437346b2c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c319c46a60c46d10f2bef5edd629400de2504ccb41fde7c091168ad803fc1534"
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
