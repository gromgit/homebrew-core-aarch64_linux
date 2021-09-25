class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.16.tar.gz"
  sha256 "877ee5e89e8445f74df95f2f3896597f04b86a4e5d0dbbca07ac71027dcb362d"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "a0732cd4c08dc6611b821e23b4476b7e836233038071e1ffc4f75aa2f1763952"
    sha256 big_sur:       "98108c1f5c334eba8122baba79933f19bd1088084f27bf4f1b0c4c5ad5578e84"
    sha256 catalina:      "078d618b46deb46ba922fc7f5e357173d0347e54d9cf5a80c1cf8fa036c218e1"
    sha256 mojave:        "31e7f7952afd4665d3f3307938267b6ed2c1a7fd5739eaf25eab1c60ad1c09e9"
    sha256 x86_64_linux:  "b012b0efbb3dc0ddb0f7c372d736841cf6c08888a09179948f79a09829a6691b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on "nlohmann-json"
  depends_on "spdlog"

  uses_from_macos "llvm" => :test

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # needs C++17

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__current_path(std::__1::error_code*)"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args, *std_cmake_args
      system "make", "all"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
