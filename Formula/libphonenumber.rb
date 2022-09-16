class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.55.tar.gz"
  sha256 "4bc493c51cdc7b833b5b24e53fea5f9799f6ed728608700779ca10a923f874d9"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cac459006e194c77c41cfc8bc331a771eb0aacc110cc5d088cee128dd8ee18d4"
    sha256 cellar: :any,                 arm64_big_sur:  "6345fd0b9215150276814e1dafe3737a15db9cdeca229dd706e20520bc7314e4"
    sha256 cellar: :any,                 monterey:       "7a5fcb1c2beb184f9152ba27d8423b5d4d6680c03186327b1c82a4b0e7c9c570"
    sha256 cellar: :any,                 big_sur:        "a289d3d09638b55eeb0199ebb3b231e81ed7229fbf718b9bffffc44011685893"
    sha256 cellar: :any,                 catalina:       "ff3a150bac792195f799c2f792eb41331913025075ff0075a8b07e2b188a5d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3431074b3a3eb8958a7d03fbd88da886d43467aaa610a5c53d109a215f9a1ae9"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
