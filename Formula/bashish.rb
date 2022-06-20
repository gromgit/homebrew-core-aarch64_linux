class Bashish < Formula
  desc "Theme environment for text terminals"
  homepage "https://bashish.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bashish/bashish/2.2.4/bashish-2.2.4.tar.gz"
  sha256 "3de48bc1aa69ec73dafc7436070e688015d794f22f6e74d5c78a0b09c938204b"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bashish"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c041ac34b527cf6b80b58052bba3b9411caf50ffa958977bf606cc8bd8e4bed4"
  end

  depends_on "dialog"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bashish", "list"
  end
end
