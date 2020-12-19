class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/1.1.3/gsmartcontrol-1.1.3.tar.bz2"
  sha256 "b64f62cffa4430a90b6d06cd52ebadd5bcf39d548df581e67dfb275a673b12a9"
  revision 7

  livecheck do
    url :stable
  end

  bottle do
    sha256 "5b936e741b0d53ac9fdbde2d64ac17f5399265157e1dcfd763cc85c8716d410c" => :big_sur
    sha256 "39046ff435ac8fe0c3e2caee12a462fcf7235c5eccaa3b7b91326f4465834941" => :catalina
    sha256 "0289b119ca79206d68ac0b4bcbb47b839f98945d85d1de1d63bb67a1ff408d14" => :mojave
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
