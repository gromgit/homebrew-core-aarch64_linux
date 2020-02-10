class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.17/libmtp-1.1.17.tar.gz"
  sha256 "f8a34cf52d9f9b9cb8c7f26b12da347d4af7eb904c13189602e4c6b62d1a79dc"

  bottle do
    cellar :any
    sha256 "edba32848630d4e88dfe923ff910b9b606c3a06499cb931893a74fa65b045e27" => :catalina
    sha256 "787180c3be62277d66b70c5d362e98ad1906648ddd6be83714f243eb2eaf4347" => :mojave
    sha256 "db8b67e377fc8297a135bf63df9945b7101627bc2d10d79c5054d20a3b9b6856" => :high_sierra
    sha256 "daeed59855f2f12403175cee945ebd11b4de41494af53618f70de779ef483939" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
