class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "811aa74f173468e9a69ab2df9cc65f7b9f6b62cf20b7829bf1eaed8989895046"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0828ce171491352a855872f30aaa5bf5c81889d4401421ec3202ebe3adf4801"
    sha256 cellar: :any_skip_relocation, big_sur:       "89cc91d46ace2eef8f2cf3a41cc34da3818388d16ed0425dfd3f25425acc90f3"
    sha256 cellar: :any_skip_relocation, catalina:      "abc78691ca9d0655f955723b1bda4e1e576f2a56fe2b810fcfac6a916d373682"
    sha256 cellar: :any_skip_relocation, mojave:        "b4085df4c799867a126e2c96be491de842e16fa630e1b98edd7819a31cf18c29"
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
