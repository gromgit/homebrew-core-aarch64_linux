class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.37.tar.gz"
  sha256 "e95c210b446ed7503b5bb46c6010e33dbd0e33348be89365d6fd630b9b8a0b68"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9693815b346d1ed61db1f26f895b09521c7f61f0b4ac14126461839475feaadf"
    sha256 cellar: :any,                 arm64_big_sur:  "7bbe4516f3fdb2425999b604b70ef65b29af8baf4db837e39b829b0811ba15ce"
    sha256 cellar: :any,                 monterey:       "666c45af9544a0c1daff75a8527d1ba868118bf1129b7e831545f2b753fa1671"
    sha256 cellar: :any,                 big_sur:        "da55278a7b32ba21a77e88d0b0044dfac59f6482a28f0bb7e3de9b92ea457e5a"
    sha256 cellar: :any,                 catalina:       "865cce61491d8abbd89ad98173adee689f72b44bea3138943bc70dd125d42bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27a488e6dfc5dcc71024157158916dbe7ef96dd45f4b01ce0a6692e7108f932c"
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
