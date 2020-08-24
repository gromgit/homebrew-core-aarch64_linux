class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200822.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200822.tar.bz2"
  sha256 "9654226a808392c365b1e7b8dea91bf4870bc4f306228d853eb700679e21be09"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a78bb25a7ab4168c770d1bfef742afffa6c35229ca96ed0ad8135113267d99c" => :catalina
    sha256 "3ba75a7522a91db40082095066738a93d7b92e24c1ed49815a528be475565eef" => :mojave
    sha256 "dda2ab83abf9acb274d260ab9b2c0751f1a0e99c31a579f50dd6846e3eefc2de" => :high_sierra
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
