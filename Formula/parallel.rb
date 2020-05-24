class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200522.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200522.tar.bz2"
  sha256 "49b4685a8b23a9f94d3ab3dff6eae5ad2283c39bf103bf56ec8cdd56b6213a82"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc0df75e722094d584a53da3f1b5c42b48b05a548f8b68aab98b904405c8f04b" => :catalina
    sha256 "dc0df75e722094d584a53da3f1b5c42b48b05a548f8b68aab98b904405c8f04b" => :mojave
    sha256 "dc0df75e722094d584a53da3f1b5c42b48b05a548f8b68aab98b904405c8f04b" => :high_sierra
  end

  conflicts_with "moreutils",
    :because => "both install a `parallel` executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
