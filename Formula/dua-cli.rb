class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.3.tar.gz"
  sha256 "aeb0935eb524d050ff68e1b80a9922cdc633ae76787015a34b6904da1a543f98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbf573529558667d79b04d0dd353fa635dd2e0440bb5c3e159dfc743be1862e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbb2ebb305be5f67e802017e8cbb99a8b0fd3e0c124067ab8807e17d0de22da6"
    sha256 cellar: :any_skip_relocation, monterey:       "c59795a7b3de4356928e1ddcb63ef36d8cb1b8b7f3f4298df863f14b7671f5d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "151be9044eeee6a0e089e684c8d8ccca8209f7e3e7cf4f4c4b08843ab1fb3511"
    sha256 cellar: :any_skip_relocation, catalina:       "7769d9d562bc0596434b105798217a2e7660ae8d13fbf6a2fe54b8c392b82163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7304dabc8a07f99030dd628d7b52777f5194b81ecc723865b6203d135543e8aa"
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
