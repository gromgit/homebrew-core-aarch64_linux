class Rancid < Formula
  desc "Really Awesome New Cisco confIg Differ"
  homepage "https://www.shrubbery.net/rancid/"
  url "https://www.shrubbery.net/pub/rancid/rancid-3.11.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/r/rancid/rancid_3.11.orig.tar.gz"
  sha256 "0678a1bad101d48d30308a8df7140eef02698b3a72b5368ff3318bd10394d21a"

  bottle do
    cellar :any_skip_relocation
    sha256 "539c7d3313b59ed60e599df7e9a1debd588b85e443ccd450e5873fbbd906ce28" => :catalina
    sha256 "e6cbd3fc7ac9c1b90eb8ea3c6ac86d9e9b9512124b66a1d2d8691321e8f7bf03" => :mojave
    sha256 "07ad1ecb48f6ccfb2c1f640925804b56accb8c4933dbd3d2c0f5c24e66ad6d56" => :high_sierra
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
