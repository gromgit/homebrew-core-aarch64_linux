class Cfengine < Formula
  desc "Help manage and understand IT infrastructure"
  homepage "https://cfengine.com/"
  url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-3.15.2.tar.gz"
  sha256 "d1c570b7a0f47794a92f66e21cccdc86b8f56a7028a389780e705db41bfd3cab"

  bottle do
    sha256 "1a1376f997d783d0ecfbb59f4061059c11bce6fb9ff6b50b412b9e6008e35bad" => :catalina
    sha256 "b4476e20cc48c9d4f936b28f322d78b874d2778a619ffa625dda725c4259642c" => :mojave
    sha256 "6bfbee4fde430d242c8178dc2805ea6491afa52cb81e7c042b6032e9b52e9754" => :high_sierra
  end

  depends_on "lmdb"
  depends_on "openssl@1.1"
  depends_on "pcre"

  resource "masterfiles" do
    url "https://cfengine-package-repos.s3.amazonaws.com/tarballs/cfengine-masterfiles-3.15.1.tar.gz"
    sha256 "051369054a2e17a4ea1f68a41198fe5377fbbf33f600168246bf0b667fc1ab74"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-workdir=#{var}/cfengine",
                          "--with-lmdb=#{Formula["lmdb"].opt_prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--without-mysql",
                          "--without-postgresql"
    system "make", "install"
    (pkgshare/"CoreBase").install resource("masterfiles")
  end

  test do
    assert_equal "CFEngine Core #{version}", shell_output("#{bin}/cf-agent -V").chomp
  end
end
