class Dmg2img < Formula
  desc "Utilities for converting macOS DMG images"
  homepage "http://vu1tur.eu.org/tools/"
  url "http://vu1tur.eu.org/tools/dmg2img-1.6.7.tar.gz"
  sha256 "02aea6d05c5b810074913b954296ddffaa43497ed720ac0a671da4791ec4d018"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dmg2img[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dmg2img"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8cbe26f8e7bee7d6f2d383640cec91da6bfc0d3d9d1aa5cd361e8a059af2d5ff"
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Patch for OpenSSL 1.1 compatibility
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/dmg2img/openssl-1.1.diff"
    sha256 "bd57e74ecb562197abfeca8f17d0622125a911dd4580472ff53e0f0793f9da1c"
  end

  def install
    system "make"
    bin.install "dmg2img"
    bin.install "vfdecrypt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dmg2img")
    output = shell_output("#{bin}/vfdecrypt 2>&1", 1)
    assert_match "No Passphrase given.", output
  end
end
