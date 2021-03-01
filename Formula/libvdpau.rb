class Libvdpau < Formula
  desc "Open source Video Decode and Presentation API library"
  homepage "https://www.freedesktop.org/wiki/Software/VDPAU/"
  url "https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/1.4/libvdpau-1.4.tar.bz2"
  sha256 "4258824c5a4555ef31de0a7d82b3caf19e75a16a13949f1edafc5f6fb2d33f30"
  license "MIT"

  livecheck do
    url "https://gitlab.freedesktop.org/vdpau/libvdpau.git"
    regex(/^(?:libvdpau[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "50169a382bb560230e7e1e5aab6c20e6027773a8557af8623183daa81205586c"
    sha256 big_sur:       "74a3ea48e33530a014162fab0c6502f7a6be8aff25b05bd5fe971dd9d39e1371"
    sha256 catalina:      "9b57bf4d53024c75f4a431fd814fa0b6f54163d13dfbb63607d41c1a43b7117d"
    sha256 mojave:        "59980ec6bf90b676354ddda5e3c93a6240c4564d1c01aa35b1f1aa804d7b949a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags vdpau")
  end
end
