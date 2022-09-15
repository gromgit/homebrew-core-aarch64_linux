class Chaiscript < Formula
  desc "Easy to use embedded scripting language for C++"
  homepage "https://chaiscript.com/"
  url "https://github.com/ChaiScript/ChaiScript/archive/v6.1.0.tar.gz"
  sha256 "3ca9ba6434b4f0123b5ab56433e3383b01244d9666c85c06cc116d7c41e8f92a"
  license "BSD-3-Clause"
  head "https://github.com/ChaiScript/ChaiScript.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/chaiscript"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4a76af12bcac01e84dec745bb8e1d93b0659daa5975da354cd3350a4089918c1"
  end


  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <chaiscript/chaiscript.hpp>
      #include <chaiscript/chaiscript_stdlib.hpp>
      #include <cassert>
      int main() {
        chaiscript::ChaiScript chai;
        assert(chai.eval<int>("123") == 123);
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-ldl", "-lpthread", "-std=c++14", "-o", "test"
    system "./test"
  end
end
