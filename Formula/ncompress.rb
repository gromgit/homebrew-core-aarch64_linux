class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v5.0.tar.gz"
  sha256 "96ec931d06ab827fccad377839bfb91955274568392ddecf809e443443aead46"
  license "Unlicense"
  head "https://github.com/vapier/ncompress.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ncompress"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "84b9a3f66ef54cc1ef60ca3c15423adcbd738d009ea411b125a920626e36ff56"
  end

  keg_only :provided_by_macos

  def install
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    Pathname.new("hello").write "Hello, world!"
    system "#{bin}/compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
