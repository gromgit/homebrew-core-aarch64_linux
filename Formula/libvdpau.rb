class Libvdpau < Formula
  desc "Open source Video Decode and Presentation API library"
  homepage "https://www.freedesktop.org/wiki/Software/VDPAU/"
  url "https://gitlab.freedesktop.org/vdpau/libvdpau/uploads/14b620084c027d546fa0b3f083b800c6/libvdpau-1.2.tar.bz2"
  sha256 "6a499b186f524e1c16b4f5b57a6a2de70dfceb25c4ee546515f26073cd33fa06"
  license "MIT"

  livecheck do
    url "https://gitlab.freedesktop.org/vdpau/libvdpau.git"
    regex(/^(?:libvdpau[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    on_macos do
      ENV.append "LDFLAGS", "-lx11"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-dri2"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags vdpau")
  end
end
