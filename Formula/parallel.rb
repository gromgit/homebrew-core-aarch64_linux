class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200622.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200622.tar.bz2"
  sha256 "ff8fafe192a76850e5640b98adb6428f8bdd85ef52c7c43787438c0ac3bc1d3f"
  head "https://git.savannah.gnu.org/git/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d421013ea570e0962c59ef15d206b2234e3b4d91c673f2497dc37f011030fdf2" => :catalina
    sha256 "d421013ea570e0962c59ef15d206b2234e3b4d91c673f2497dc37f011030fdf2" => :mojave
    sha256 "d421013ea570e0962c59ef15d206b2234e3b4d91c673f2497dc37f011030fdf2" => :high_sierra
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
