class Unixodbc < Formula
  desc "ODBC 3 connectivity for UNIX"
  homepage "http://www.unixodbc.org/"
  url "http://www.unixodbc.org/unixODBC-2.3.8.tar.gz"
  sha256 "85372b9cd2cdfea3983c3958ab11ca1513ea091a263d82105e5da043379e48a5"
  license "LGPL-2.1-or-later"

  livecheck do
    url "http://www.unixodbc.org/download.html"
    regex(/href=.*?unixODBC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "b0df0122140e5b40cf874b0334c6a7bfc1cd5acc79ceffde21f9b95c56c27cc6" => :catalina
    sha256 "7cd0f37108f83ec9079cd22592e4afc528d726bba5dafb7a93cc8a62ffcd7961" => :mojave
    sha256 "6d0f38787107264f9e55563625b18d8c5a744da061925c37ee013c538001f875" => :high_sierra
  end

  depends_on "libtool"

  conflicts_with "libiodbc", because: "both install `odbcinst.h`"
  conflicts_with "virtuoso", because: "both install `isql` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-static",
                          "--enable-gui=no"
    system "make", "install"
  end

  test do
    system bin/"odbcinst", "-j"
  end
end
