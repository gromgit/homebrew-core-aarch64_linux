class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.32.tar.xz"
  sha256 "a66e3d8f2b7e65178d786a01ef61f2a0a0b4d0b8370de7ce134ba73da4af18f0"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?([\d.]+\.[\d.]+\.[\d.]+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "c4a11fbf1e2d645b0bbcbabc467c6f7fe604282833ece90264b063806a1e4909" => :catalina
    sha256 "b9c58730d763ca611867504ff7005245e95ca435b027d85ff7f7471dc7431b59" => :mojave
    sha256 "b732bc9e7fa9825222b0dda3dfdbe7f38cf45aeb46c239f432fc646d98079e76" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dgtk_doc=disabled", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/orcc", "--version"
  end
end
