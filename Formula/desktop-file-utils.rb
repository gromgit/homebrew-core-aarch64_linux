class DesktopFileUtils < Formula
  desc "Command-line utilities for working with desktop entries"
  homepage "https://wiki.freedesktop.org/www/Software/desktop-file-utils/"
  url "https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.25.tar.xz"
  sha256 "438199400333300fb8a14033d7c2f24ce3cf2e300312da9ff0b3337e35d06b8e"

  bottle do
    sha256 "44cf2d14136f1cb8db3f8718c91191d90a3ca0196f7407d69311d08318807268" => :catalina
    sha256 "261a93f32847cacd90116ab52adb2390fc2c3f8a6dd494c8c1cd4b363f67e7c5" => :mojave
    sha256 "5d4fa139c491db6e82bf48c1325c202fe14c82db1450b8e1bf6ea9dbfae5663f" => :high_sierra
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
