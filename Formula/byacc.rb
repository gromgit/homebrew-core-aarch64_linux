class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20191125.tgz"
  sha256 "071c2ebe36afaa8448b80e893473a681e63a3b8a4ed636c0d675780a02411cde"

  bottle do
    cellar :any_skip_relocation
    sha256 "040e04d0467bd4f309ec7acb5e4cba9e46a3598f7b22863ef27c48e28cedc001" => :catalina
    sha256 "a007360d6a19bf4eeba330220b6bdc9cb23e997d6cbc2340267a07ceec2ea57f" => :mojave
    sha256 "2cf04e3cdb3df355ef05eacfc31219ba6a5e8d37c7ba9fb9389bba66681696cd" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
