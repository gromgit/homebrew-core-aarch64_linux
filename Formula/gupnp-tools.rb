class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.2.tar.xz"
  sha256 "6de49ef4b375b8a164f74b766168b1184e0d28196b6b07a4f5341f08dfd85d6c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 arm64_monterey: "60c27e301bcaba5c95b491b9865db6b453a92e8a403f0d4897b6fe16a10689aa"
    sha256 arm64_big_sur:  "8418c2570591b15a49305251ef6e56a78def7ed72f848f1bd02a303e8416e6e3"
    sha256 monterey:       "743c63f60784485413f15bf30cbd0a6164ce4f463dab22a2cbb3d5abb8241771"
    sha256 big_sur:        "512b29e2e56968496991b3ba51952e21bf47353caa4625aceae382969f78047b"
    sha256 catalina:       "2da164d05b713d158b8e537ee77cbd32546bef71223c23f067205b8e9c750fc0"
    sha256 x86_64_linux:   "a131f92a504507638f37272d73bfc5d0e546dab25aa2664507e7b1a09bbe7517"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup@2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
