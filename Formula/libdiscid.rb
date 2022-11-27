class Libdiscid < Formula
  desc "C library for creating MusicBrainz and freedb disc IDs"
  homepage "https://musicbrainz.org/doc/libdiscid"
  url "http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz"
  mirror "https://ftp.osuosl.org/pub/musicbrainz/libdiscid/libdiscid-0.6.2.tar.gz"
  sha256 "f9e443ac4c0dd4819c2841fcc82169a46fb9a626352cdb9c7f65dd3624cd31b9"
  license "LGPL-2.1"

  livecheck do
    url "https://ftp.osuosl.org/pub/musicbrainz/libdiscid/"
    regex(/href=.*?libdiscid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libdiscid"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b9714b94929532abf323ef41f712dd494e0a164c1f22bc599a5031fbddac88e2"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
