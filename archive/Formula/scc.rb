class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v3.0.0.tar.gz"
  sha256 "01b903e27add5180f5000b649ce6e5088fa2112e080bfca1d61b1832a84a0645"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/scc"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2897b2c5a7db3d9a8d3363b1829d1c6a1299f6954a10ffeb0e5c5f98af32561b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes
      C,4,4,0,0,0,50
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
