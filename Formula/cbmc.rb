class Cbmc < Formula
  desc "CBMC: The C Bounded Model Checker"
  homepage "https://www.cprover.org/cbmc/"
  url "https://github.com/diffblue/cbmc.git",
      :using    => :git,
      :tag      => "cbmc-5.12.1",
      :revision => "91a225785f470df56e1d6663675c3eab958e00a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "52b5ad464f019dcdaf68ee858d6af50c4b9e49118107a5e0c8c9ba9be0e4c9b2" => :catalina
    sha256 "31137c7bc739c209d0c0095ec89a8bafa3c60fd77c5dac44b5dbba4906986be9" => :mojave
    sha256 "6465989e477f4c92ae1943a13b3e1f1251300c98d6f1c5e61c97fd1cee451f0f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openjdk" => :build

  def install
    system "git", "submodule", "update", "--init"

    # Build CBMC
    system "cmake", std_cmake_args, "-S.", "-Bbuild"
    system "cmake", "--build", "build"

    # Install CBMC
    #  CBMC 5.12 does not come with an install target
    #  Pull request submitted to add install target to CBMC 5.13:
    #    https://github.com/diffblue/cbmc/pull/5320
    bin.install "build/bin/cbmc"
    bin.install "build/bin/goto-analyzer"
    bin.install "build/bin/goto-cc"
    bin.install "build/bin/goto-diff"
    bin.install "build/bin/goto-gcc"
    bin.install "build/bin/goto-harness"
    bin.install "build/bin/goto-instrument"
    bin.install "build/bin/janalyzer"
    bin.install "build/bin/java-unit"
    bin.install "build/bin/jbmc"
    bin.install "build/bin/jdiff"
    man1.install "doc/man/cbmc.1"
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
