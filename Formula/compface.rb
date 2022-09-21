class Compface < Formula
  desc "Convert to and from the X-Face format"
  homepage "https://web.archive.org/web/20170720045032/freecode.com/projects/compface"
  url "https://mirrorservice.org/sites/ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.heanet.ie/mirrors/ftp.xemacs.org/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz"
  sha256 "a6998245f530217b800f33e01656be8d1f0445632295afa100e5c1611e4f6825"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/compface"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1bb75f14f494de7ef302a177f2949a39211a5e34fb365a9cead98d0b3b75faf2"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    system bin/"uncompface"
  end
end
