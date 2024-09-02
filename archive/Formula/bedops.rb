class Bedops < Formula
  desc "Set and statistical operations on genomic data of arbitrary scale"
  homepage "https://github.com/bedops/bedops"
  url "https://github.com/bedops/bedops/archive/v2.4.41.tar.gz"
  sha256 "3b868c820d59dd38372417efc31e9be3fbdca8cf0a6b39f13fb2b822607d6194"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bedops"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ba933a550166b0877437ccd3f51b5e5561bb7fa4a94a6064ee978e326354d29b"
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
