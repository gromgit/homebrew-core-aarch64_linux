class Msktutil < Formula
  desc "Program for interoperability with Active Directory"
  homepage "https://code.google.com/p/msktutil/"
  url "https://msktutil.googlecode.com/files/msktutil-0.5.1.tar.bz2"
  sha256 "ec02f7f19aa5600c5d20f327beaef88ee70211841dc01fa42eb258ae840ae6f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed2c180be51a19de7b014a28d8f34310f87f283f03ba72cc55f9ac0a5c249e3b" => :el_capitan
    sha256 "678a75fcba0b6c1ba926845b07bde8bff4ae96b3f069d62a3ceb853da474fe2a" => :yosemite
    sha256 "fba7badc2d24de3a5e8e84d274a37d9007c938d877ab34fa2b91110b91eacb10" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
