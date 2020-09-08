class Gstreamer < Formula
  desc "Development framework for multimedia applications"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.18.0.tar.xz"
  sha256 "0ff09245b06c0aeb5d9a156edcab088a7e8213a0bf9c84a1ff0318f9c00c7805"
  license "LGPL-2.0-or-later"
  head "https://anongit.freedesktop.org/git/gstreamer/gstreamer.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gstreamer/"
    regex(/href=.*?gstreamer[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "3473eef6aadd51a378f722c08a399922c4b401f38d8d5bffe7e2cb0ba845f919" => :catalina
    sha256 "6427cd64ac1c541d35fc57f869dd1290e57aab8a2a9f5589b79f6e078e4432d5" => :mojave
    sha256 "b1a6cbfbac2bb152ce023fbe283ef38ec371ceccff48ae1545cdeac1a36933ba" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "flex" => :build

  # Patch submitted upstream at
  # https://gitlab.freedesktop.org/gstreamer/gstreamer/-/merge_requests/620
  patch do
    url "https://gitlab.freedesktop.org/gstreamer/gstreamer/-/commit/40c994cddee41954053f80dde40f56107ddfcfd4.patch"
    sha256 "ff275d2709b257f592ca03b1f4eb63324a27e5637e6a4f6e9d97dc2727051bb5"
  end

  def install
    # Ban trying to chown to root.
    # https://bugzilla.gnome.org/show_bug.cgi?id=750367
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dptp-helper-permissions=none
    ]

    # Look for plugins in HOMEBREW_PREFIX/lib/gstreamer-1.0 instead of
    # HOMEBREW_PREFIX/Cellar/gstreamer/1.0/lib/gstreamer-1.0, so we'll find
    # plugins installed by other packages without setting GST_PLUGIN_PATH in
    # the environment.
    inreplace "meson.build",
      "cdata.set_quoted('PLUGINDIR', join_paths(get_option('prefix'), get_option('libdir'), 'gstreamer-1.0'))",
      "cdata.set_quoted('PLUGINDIR', '#{HOMEBREW_PREFIX}/lib/gstreamer-1.0')"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def caveats
    <<~EOS
      Consider also installing gst-plugins-base and gst-plugins-good.

      The gst-plugins-* packages contain gstreamer-video-1.0, gstreamer-audio-1.0,
      and other components needed by most gstreamer applications.
    EOS
  end

  test do
    system bin/"gst-inspect-1.0"
  end
end
