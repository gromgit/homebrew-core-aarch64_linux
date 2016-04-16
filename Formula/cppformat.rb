class Cppformat < Formula
  desc "Open-source formatting library for C++"
  homepage "https://cppformat.github.io/"
  url "https://github.com/cppformat/cppformat/releases/download/2.1.1/cppformat-2.1.1.zip"
  sha256 "7c6c739291c4a97eec95a758b2a2243f43c79dfa2d1e94e33c09a6736de6c427"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b1ef0852ab31be3d350262d4a002a3a0de4d99191454968607b629d6728a034" => :el_capitan
    sha256 "e8a3d6249d417f6a56e012b7327239ba5ab1993264260a612b5108e017cb5c66" => :yosemite
    sha256 "eaf14af839288acc850ac113ccd9116cb51e1366344d4c2e17d8b1070bd29aa6" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <string>
      #include <cppformat/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lcppformat"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
