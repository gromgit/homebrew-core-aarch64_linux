class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.0.0.tar.gz"
  sha256 "517dd80ebd0569f31498887338eacb92e8cf054bc4625eef8ffe9ea174c1adae"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 "ec8134b5087e85f7c7fc1e99705107167d4dd7a702405bb423286ed754e32fbc" => :big_sur
    sha256 "4e89bca3b80f1adbbcbc375ca69766584fdc02de638e04b6f2aab441d0d31184" => :catalina
    sha256 "9b47bdbfc447a4f4a3ece3375209b6a378b444d06f1f5b1b8902de9ccdb9494a" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end
