class Mpage < Formula
  desc "Many to one page printing utility"
  homepage "https://mesa.nl/pub/mpage/README"
  url "https://mesa.nl/pub/mpage/mpage-2.5.7.tgz"
  sha256 "51ab9c4e5fdd37e03c90df6756f30c0b61a34f066cb625f8924feedc4b3ec3fe"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mpage"
    sha256 aarch64_linux: "ce2c97608cd9dc8ed18895b7df201a1b8e3288ea7b6b90e621bdddc894faea03"
  end

  def install
    args = %W[
      MANDIR=#{man1}
      PREFIX=#{prefix}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    (testpath/"input.txt").write("Input text")
    system bin/"mpage", "input.txt"
  end
end
