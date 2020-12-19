class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 8

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d35eb9fcef537fc21c297083629239973050d6da92c75ea07f99bbebf1c9c505" => :big_sur
    sha256 "99f4ec56915a85c7c38d059ce6b7655e3a3ab1f7911afa778a7dbae64a818229" => :catalina
    sha256 "beab95cdf1fd5926bef93b096e4de7a0df00f30020bd1276386150e3d452ae5d" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gtkmm3"
  depends_on "pcre"
  depends_on "smartmontools"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/gsmartcontrol", "--version"
  end
end
