class Grt < Formula
  desc "Gesture Recognition Toolkit for real-time machine learning"
  homepage "https://nickgillian.com/grt/"
  url "https://github.com/nickgillian/grt/archive/v0.2.4.tar.gz"
  sha256 "55bcabe7a58916461dc4341758eff2a45bd5b236c263dfe6e58c176c1a7e1ac4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/grt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b2b33cfa8c5434b348e60440ef6241ab81e4e0e080c85a61af784c2140b021b7"
  end

  depends_on "cmake" => :build

  def install
    cd "build"
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <GRT/GRT.h>
      int main() {
        GRT::GestureRecognitionPipeline pipeline;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lgrt", "-o", "test"
    system "./test"
  end
end
