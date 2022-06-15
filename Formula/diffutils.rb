class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.8.tar.xz"
  sha256 "a6bdd7d1b31266d11c4f4de6c1b748d4607ab0231af5188fc2533d0ae2438fec"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/diffutils"
    sha256 aarch64_linux: "5ca1e7727b8ec2e37124e07ef921ba50508ecfeb75923d7ae170d8f7d87eacd0"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
