class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.25.tar.xz"
  sha256 "438199400333300fb8a14033d7c2f24ce3cf2e300312da9ff0b3337e35d06b8e"

  bottle do
    sha256 "7d96376b59d36fa9a7b7be5a116ec0ebaef113624d0f1b91fdd77bdabfca9286" => :catalina
    sha256 "2e57d92d8b0385a97a55d6aa32b191a144b329c1b73f85f7465f7c2ab0f2c40f" => :mojave
    sha256 "12281d3b3e388bb2f9149ec6b229d44b8b1e65a01e5ecfbde482c7ebb9cec6b9" => :high_sierra
    sha256 "16405a7ca997e90c3448d86f291b8d8793cf413ccd95090f64e05bfbb10cb7e9" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"

      # fix lisp file install location
      mkdir_p share/"emacs/site-lisp/desktop-file-utils"
      mv share/"emacs/site-lisp/desktop-entry-mode.el", share/"emacs/site-lisp/desktop-file-utils"
    end
  end

  test do
    (testpath/"test.desktop").write <<~EOS
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Foo Viewer
      Comment=The best viewer for Foo objects available!
      TryExec=fooview
      Exec=fooview %F
      Icon=fooview
      MimeType=image/x-foo;
      Actions=Gallery;Create;

      [Desktop Action Gallery]
      Exec=fooview --gallery
      Name=Browse Gallery

      [Desktop Action Create]
      Exec=fooview --create-new
      Name=Create a new Foo!
      Icon=fooview-new
    EOS
    system "#{bin}/desktop-file-validate", "test.desktop"
  end
end
