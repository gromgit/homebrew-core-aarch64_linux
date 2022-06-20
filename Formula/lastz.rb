class Lastz < Formula
  desc "Pairwise aligner for DNA sequences"
  homepage "https://lastz.github.io/lastz/"
  url "https://github.com/lastz/lastz/archive/refs/tags/1.04.15.tar.gz"
  sha256 "46a5cfb1fd41911a36fce5d3a2721ebfec9146952943b302e78b0dfffddd77f8"
  license "MIT"
  head "https://github.com/lastz/lastz.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/lastz"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cc81956d688f1c7f2e3ef02d5572d79045debded4a2826c3431c5da04b88a696"
  end

  def install
    system "make", "install", "definedForAll=-Wall", "LASTZ_INSTALL=#{bin}"
    doc.install "README.lastz.html"
    pkgshare.install "test_data", "tools"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastz --version", 1)
    assert_match "MAF", shell_output("#{bin}/lastz --help=formats", 1)
    dir = pkgshare/"test_data"
    assert_match "#:lav", shell_output("#{bin}/lastz #{dir}/pseudocat.fa #{dir}/pseudopig.fa")
  end
end
