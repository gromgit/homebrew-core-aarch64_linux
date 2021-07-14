class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "05e7c67d986369a8fc53237522c6f696357fb9f0fe5c823da601653fb5c5a1fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2af06b2af8b5ee22b8c66d99efaceab604d9e7bed861bbde322d54a8618e8648"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf6cf95bb05032a979ab1c508aef094b98337cdaa46aae31002bbc65307fef41"
    sha256 cellar: :any_skip_relocation, catalina:      "afc6dda4a643fa2215890068a1732473575d38339b981e1500d4b8e4d743e86d"
    sha256 cellar: :any_skip_relocation, mojave:        "080c10c2ddef2107076e9640cbe5148362199f6d521f8a1118091256884ae528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04565e9441bdc740d6fe892c677bd5f50427c8210f912500a53aa60d0444ebba"
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
