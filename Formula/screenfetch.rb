class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.9.1.tar.gz"
  sha256 "aa97dcd2a8576ae18de6c16c19744aae1573a3da7541af4b98a91930a30a3178"
  license "GPL-3.0"
  head "https://github.com/KittyKatt/screenFetch.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/screenfetch"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a3f250fbb00e345c4c5cca1c1583e85ba93578c8466c7de94281f6afb6ce73f9"
  end

  # `screenfetch` contains references to `/usr/local` that
  # are erronously relocated in non-default prefixes.
  pour_bottle? only_if: :default_prefix

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
