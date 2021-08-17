class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.5.tar.gz"
  sha256 "f2d3871e1d52bed411cbfbb803c55079553662882adb9297ff1d590be718b296"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93aef21d2f92024cead7c5201498f499dfac4210bfa662ce63b49d0934242bd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "c54cf247b989dec31103ae2dfa3a70bf455e861f245dafa273bbed5585db603d"
    sha256 cellar: :any_skip_relocation, catalina:      "0768e3d8e602f4bcf2beed2ec951389fa3b6700a52f67b15ecbf66c04268a3e7"
    sha256 cellar: :any_skip_relocation, mojave:        "5d0e4de284c911389c8268903ae408d16908b6b83095bf79fff03197b268d018"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6980803eb155fe645abb87ebf249c77d4f32b6dc6f82ea79376973a5a58e9f14"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
