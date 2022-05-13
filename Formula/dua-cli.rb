class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.17.5.tar.gz"
  sha256 "805a911300bbb5234c25f607b25444988a97c260c03c02932844aeee0ba108e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa6a9d66ce4a8e4c4291cc2fe3722d50c5e228fc7e5db2d5081e8e07680e306f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59a046772504e3a3b1f22b0a851ed3bd2c9cfd872b5484df3d56eae0456c9d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "71367cbd189d1402027b59ba1f8bf10702a7828b784c7b264607d01e27f798e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "324890547ab10bf2037e679d5c5af783ad2bdbb7ef7536931e479f07ab2f9b8c"
    sha256 cellar: :any_skip_relocation, catalina:       "7803368131eb3479e627fa421b048928bce5630ae6455fe1ea6888f32e004255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "776d65307d1233c1f90f066046e031e562ab754de8f48fbb4cc7fea749ef6a74"
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
