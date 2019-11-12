class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v2.10.1.tar.gz"
  sha256 "98a09aeeb3e6727b1663e8d9f8ac9bb53303928634fd3761464f34de4b382970"

  bottle do
    cellar :any_skip_relocation
    sha256 "00f03832d26812c1eb6c9bbb7593bd3947337ed38f3c136e5e5f185c3bc68183" => :catalina
    sha256 "f98f09fc75a7f06a026bc355179c563e570b56c5be7726a3c0740c410a99cd53" => :mojave
    sha256 "c3b3c917bba3db5bd0818493ef211e36a170ec9651e1c1291d897da03bb666e5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/boyter/scc/").install Dir["*"]
    system "go", "build", "-o", "#{bin}/scc", "-v", "github.com/boyter/scc/"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "C,test.c,test.c,4,4,0,0,0\n", shell_output("#{bin}/scc -fcsv test.c")
  end
end
