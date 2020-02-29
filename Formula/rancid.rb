class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "https://www.shrubbery.net/rancid/"
  url "https://www.shrubbery.net/pub/rancid/rancid-3.11.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/r/rancid/rancid_3.11.orig.tar.gz"
  sha256 "0678a1bad101d48d30308a8df7140eef02698b3a72b5368ff3318bd10394d21a"

  bottle do
    cellar :any_skip_relocation
    sha256 "59241ac50b1a4cc52ae7be4117421e7e2d0a2f9acc815a072f6d7c168f1cb9c2" => :catalina
    sha256 "d7d5c086f9e47d940e797877c4710852dada2fc4fd027440b4872a6a0fe94a2c" => :mojave
    sha256 "8d91366e56912ad5ec442c84aca2c2dc02d19e56fb0c9a8feae982795e893c40" => :high_sierra
  end

  conflicts_with "par", :because => "both install `par` binaries"

  def install
    system "./configure", "--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"rancid.conf").write <<~EOS
      BASEDIR=#{testpath}; export BASEDIR
      CVSROOT=$BASEDIR/CVS; export CVSROOT
      LOGDIR=$BASEDIR/logs; export LOGDIR
      RCSSYS=git; export RCSSYS
      LIST_OF_GROUPS="backbone aggregation switches"
    EOS
    system "#{bin}/rancid-cvs", "-f", testpath/"rancid.conf"
  end
end
