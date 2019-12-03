class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/6.1.0.tar.gz"
  sha256 "8fb84291a7ed6b4db4769115b57fa56d5467b1ab8c3ba5bdf78c820e4bd17944"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaa5c179981f243ab57a57fb90362ac7a14cc851ac65fbbcbe1716518bd28c36" => :catalina
    sha256 "c3870b59734b9c1ee85026e6f6120863054817c4564adc5bbbbcf12e3aae3518" => :mojave
    sha256 "31d52dbff6a5e606791da84ddfdd4fb26f5a96817e1fd86173da83fe13408a65" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
