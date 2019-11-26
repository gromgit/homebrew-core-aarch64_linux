class Libusbmuxd < Formula
  desc "USB multiplexor library for iOS devices"
  homepage "https://www.libimobiledevice.org/"

  stable do
    url "https://github.com/libimobiledevice/libusbmuxd/archive/2.0.1.tar.gz"
    sha256 "f93faf3b3a73e283646f4d62b3421aeccf58142266b0eb22b2b13dd4b2362eb8"
  end

  bottle do
    cellar :any
    sha256 "cd86a52e7d94295f6ddb4f61449f349f22e6ebe0dec876904a0bdde78869035b" => :catalina
    sha256 "c296286ac58e0afbd167f37b7be5ced50c104252d69878e9a54f33268eb54a54" => :mojave
    sha256 "c37185be694168115ef33c17794a3a00ef3e917ade673f0a6a7f39fb3a9dd5dd" => :high_sierra
  end

  head do
    url "https://github.com/libimobiledevice/libusbmuxd.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "libusb"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iproxy"
  end
end
