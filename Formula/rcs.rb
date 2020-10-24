class Rcs < Formula
  desc "GNU revision control system"
  homepage "https://www.gnu.org/software/rcs/"
  url "https://ftp.gnu.org/gnu/rcs/rcs-5.10.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/rcs/rcs-5.10.0.tar.xz"
  sha256 "3a0d9f958c7ad303e475e8634654974edbe6deb3a454491f3857dc1889bac5c5"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "48a77f06f4568a177b0b2e10fde07ee3c2833f34478472cf6b3ce94124d10ee2" => :catalina
    sha256 "f24fb3b2f14d19bf02bc5b4c325f7735ec4657b43fac8e6a8a7e6a2e5551851c" => :mojave
    sha256 "f43c9160cbc605578af4473892f71f733dc05a9ab836d280400acece9cb75708" => :high_sierra
    sha256 "f082af49e1b1570892fa76b91bed0246e9ad63e59f953e0388b20dbf55edc485" => :sierra
    sha256 "4681c5fae05b4f4b267a9bccc9032de2b216437105d591ec5de7a10ca31e0441" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
