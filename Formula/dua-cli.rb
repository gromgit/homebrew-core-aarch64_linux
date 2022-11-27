class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.2.tar.gz"
  sha256 "759ff122112d3c1219973c8dbb5a77adf311d082f89ace18a8e6012a644f90e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb762cf99763fba9e75eab56d18f35a9e0daa5843b937778df185486880d6094"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a7ed822a1317d69e2c8bf3607a16a05327583191453964c524df431a8a9f0e5"
    sha256 cellar: :any_skip_relocation, monterey:       "90ee0dd51ab33aff78b1cd58cbadcb6063f49258a2eb26ab86a7df702610e711"
    sha256 cellar: :any_skip_relocation, big_sur:        "56b93a607ffe9149a156af64ff00a73c3ac24dac86bc560c863a72d290afaabd"
    sha256 cellar: :any_skip_relocation, catalina:       "04e92a6322ec6c29ab1a689385078dec5790d69845cf94922546f9dae64d5001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ede82a13f5c82a0d4e79c7f62f24ac953a7e4d0a0750d9ff661dd84859a199ff"
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
