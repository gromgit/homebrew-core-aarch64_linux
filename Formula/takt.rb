class Takt < Formula
  desc "Text-based music programming language"
  homepage "https://takt.sourceforge.io"
  url "https://downloads.sourceforge.net/project/takt/takt-0.310-src.tar.gz"
  sha256 "eb2947eb49ef84b6b3644f9cf6f1ea204283016c4abcd1f7c57b24b896cc638f"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/takt"
    sha256 aarch64_linux: "e67448f4b6fdae5b573dc8d394ddf17637aef7d9f0ecdb747c0e7c9360b07142"
  end

  depends_on "readline"

  on_linux do
    depends_on "alsa-lib"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    system bin/"takt", "-o etude1.mid", pkgshare/"examples/etude1.takt"
  end
end
