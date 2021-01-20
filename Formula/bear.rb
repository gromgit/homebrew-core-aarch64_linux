class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.7.tar.gz"
  sha256 "90004c7f8c83b81b3c6d9a1dced83e6cc212f60a1d1434b934ae0cf0045b3193"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "9862a97801676dcc319cbc7a41c5a8bc25dcf1605699c151ddaa31a152b73763" => :big_sur
    sha256 "5461a907f535dc454ee4e02b720542ca7e6557ba2356919d6bcded0b619cb230" => :arm64_big_sur
    sha256 "84cf802302f75a97d460d81b34388f1b426739251a0a1ef693798974de8b20bb" => :catalina
    sha256 "cf53da69c793f2eebdfe625ffd6776d4f3a7a36a440eeb027ec75bc27865acad" => :mojave
    sha256 "9e0070f18b84c96e10c0305c016e75129d51b9d480424b12563a1979b2a7e297" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on macos: :catalina
  depends_on "nlohmann-json"
  depends_on "python@3.9"
  depends_on "spdlog"
  depends_on "sqlite"

  def install
    args = std_cmake_args + %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "install"
    end

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system "#{bin}/bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
