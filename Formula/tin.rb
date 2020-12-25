class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "https://www.nic.funet.fi/pub/unix/news/tin/v2.4/tin-2.4.5.tar.xz"
  sha256 "1a14e6a49a3627230f792eb48936d39d0abd7b04d958083a6296bb4210c6c512"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(%r{tin-current\.t.*?>TIN v?(\d+(?:\.\d+)+)</A>.*?stable}i)
  end

  bottle do
    sha256 "f6ecb72caaa1d89772b4d4a52046ccfc40ce1eff2de619e4bf6cf7cdf5221495" => :big_sur
    sha256 "3c531db6fec66e40f5a9f93edf37a4115c40b83fb9a7a741ae59994e67a14d73" => :arm64_big_sur
    sha256 "61d6592e64a27ef72707338b98fb80fecd92e6679510f1734a301e0618fb7818" => :catalina
    sha256 "23f5488623cc0c8fa0765541a56a6fa714e07b1f7194144f05bb4e4a22931037" => :mojave
  end

  depends_on "gettext"

  conflicts_with "mutt", because: "both install mmdf.5 and mbox.5 man pages"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
