class Gsl < Formula
  desc "Numerical library for C and C++"
  homepage "https://www.gnu.org/software/gsl/"
  url "https://ftp.gnu.org/gnu/gsl/gsl-2.7.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsl/gsl-2.7.1.tar.gz"
  sha256 "dcb0fbd43048832b757ff9942691a8dd70026d5da0ff85601e52687f6deeb34b"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gsl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0da8e24887b40a48e70c18a974421ebd91f462e82132caecfe82f309d89d4edb"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make", "install"
  end

  test do
    system bin/"gsl-randist", "0", "20", "cauchy", "30"
  end
end
