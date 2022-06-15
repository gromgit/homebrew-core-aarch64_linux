class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/1.0.4.tar.gz"
  sha256 "839c6a30be2c974bba70ab80faf8167713955bb010427662b14d4af7df8d5f19"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dylibbundler"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1bd2e803a89eeb0dd98123a66214ec1baaef62533db97a4af5e0ef52d6f02d84"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system "#{bin}/dylibbundler", "-h"
  end
end
