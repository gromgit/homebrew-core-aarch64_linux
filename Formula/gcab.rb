class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.4/gcab-1.4.tar.xz"
  sha256 "67a5fa9be6c923fbc9197de6332f36f69a33dadc9016a2b207859246711c048f"

  bottle do
    sha256 "89ab0f14efac9b2daea83b157a2fa46d9ab20c02cb649d8527b021ca1dc3b387" => :catalina
    sha256 "504b51791d61119bfc8a378cce00b2b1c7f9cf85bfc833ee75b74647aabe5e36" => :mojave
    sha256 "b41c08852ef80aa118629092f66c4b3d465649e32756d6ecaf6588a6a88ad0b3" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gcab", "--version"
  end
end
