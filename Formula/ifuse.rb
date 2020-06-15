class Ifuse < Formula
  desc "FUSE module for iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ifuse/archive/1.1.4.tar.gz"
  sha256 "2a00769e8f1d8bad50898b9d00baf12c8ae1cda2d19ff49eaa9bf580e5dbe78c"
  head "https://cgit.sukimashita.com/ifuse.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8a9233151be9f9d521a6d4be9aa052215b6de0e5d7a1efbe0bedf1ef52e38ebb" => :catalina
    sha256 "e39c8c8d45a60b65acb5ea39001f67724d90a9cef2d4f99d35f719b933ff15ee" => :mojave
    sha256 "0f0a95935b2004ea58982f2a095c33365d9ba4e23c75f62c3e38b7bee75c85b6" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Actual test of functionality requires osxfuse, so test for expected failure instead
    assert_match "ERROR: No device found!", shell_output("#{bin}/ifuse --list-apps", 1)
  end
end
