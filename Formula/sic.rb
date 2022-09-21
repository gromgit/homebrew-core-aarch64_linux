class Sic < Formula
  desc "Minimal multiplexing IRC client"
  homepage "https://tools.suckless.org/sic/"
  url "https://dl.suckless.org/tools/sic-1.2.tar.gz"
  sha256 "ac07f905995e13ba2c43912d7a035fbbe78a628d7ba1c256f4ca1372fb565185"
  license "MIT"
  head "https://git.suckless.org/sic", branch: "master", using: :git

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?sic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sic"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e511f87505d20140a0c77d1cd6b12dd14ee0d84e4b3f31e7a8520ae00c392418"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
