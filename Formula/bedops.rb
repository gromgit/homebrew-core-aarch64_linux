class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.40.tar.gz"
  sha256 "8c01db76669dc58c595e2e1b9bdb6d462f3363fc569b15c460a63a63b8b6bf30"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bedops"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4f717d0cb6a17047d3e5ee50a1fec2c235fe67c793aa4280a9d0c1b8653f9e39"
  end

  def install
    system "make"
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    (testpath/"first.bed").write <<~EOS
      chr1\t100\t200
    EOS
    (testpath/"second.bed").write <<~EOS
      chr1\t300\t400
    EOS
    output = shell_output("#{bin}/bedops --complement first.bed second.bed")
    assert_match "chr1\t200\t300", output
  end
end
