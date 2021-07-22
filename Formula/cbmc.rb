class Cbmc < Formula
  desc "C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      tag:      "cbmc-5.35.0",
      revision: "7e291a5232bf0dcae9feba0281d371b83491d832"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a15c21cc088d7c24ef82bfc21f7dfe6d623970eab6adf15d47af9ea9b01b682f"
    sha256 cellar: :any_skip_relocation, catalina: "7da20351c1e2581bc09ea723a99339d9d4a40f24e73476f2c187ba7bf92c7166"
    sha256 cellar: :any_skip_relocation, mojave:   "73f956a3042c0e78c7c3049a55264325655e6c11c43e6dddc338c6bb1089e44f"
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    args = std_cmake_args + %w[
      -DCMAKE_C_COMPILER=/usr/bin/clang
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "make", "install"
    end

    libexec.install lib
  end

  test do
    # Find a pointer out of bounds error
    (testpath/"main.c").write <<~EOS
      #include <stdlib.h>
      int main() {
        char *ptr = malloc(10);
        char c = ptr[10];
      }
    EOS
    assert_match "VERIFICATION FAILED",
                 shell_output("#{bin}/cbmc --pointer-check main.c", 10)
  end
end
