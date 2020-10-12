class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.18/libmtp-1.1.18.tar.gz"
  sha256 "7280fe50c044c818a06667f45eabca884deab3193caa8682e0b581e847a281f0"
  license "LGPL-2.1"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "47ef836719d1fc0ddfc64528d93f1892a4b1db55cc73b025d5824a53956b8ff6" => :catalina
    sha256 "dab56fa876053034299e6a5e6ccdc56d8f55b2b6eba89cb7fc402d011f3e5318" => :mojave
    sha256 "89264c49b080c39b588ffa5f4ecad60aaa68aca5baf92a6460defee779c4733e" => :high_sierra
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
