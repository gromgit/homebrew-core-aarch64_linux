class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"
  license "Unlicense"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libtomcrypt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "21b363b9b80c59d09da3d74db3e1fc9d41e9ca71abe0b2416f01561329bf1d21"
  end

  def install
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test"
    (pkgshare/"tests").install "tests/test.key"
  end

  test do
    cp_r Dir[pkgshare/"*"], testpath
    system "./test"
  end
end
