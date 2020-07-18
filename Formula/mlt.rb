class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  license "LGPL-2.1"
  revision 1

  stable do
    url "https://github.com/mltframework/mlt/archive/v6.20.0.tar.gz"
    sha256 "ab211e27c06c0688f9cbe2d74dc0623624ef75ea4f94eea915cdc313196be2dd"

    depends_on "opencv@3"

    # Fix build with Qt 5.15.0, details: https://github.com/mltframework/mlt/pull/534
    patch do
      url "https://github.com/mltframework/mlt/commit/f58b44d73442986eeffec7431e59b7d19d214c1b.patch?full_index=1"
      sha256 "9427dfffdc1a08fcbeb093d0575637386a6fd470807eecb32c55cba98af95708"
    end
  end

  bottle do
    sha256 "e81b8558b3d04eabd9d02084cad01278b2f3ae64c37edbbe8c5026983aac829e" => :catalina
    sha256 "59d187ff682eb6e586f2223c79288b1cb8833a306260539bd12adaeeddab562d" => :mojave
    sha256 "a376edfbe8b4d526b52da5df322d0bb6c1c0daaf8caefd57c25d8715d218b388" => :high_sierra
  end

  head do
    url "https://github.com/mltframework/mlt.git"

    depends_on "gdk-pixbuf"
    depends_on "opencv"
    depends_on "pango"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "frei0r"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "sox"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec",
            "--disable-gtk",
            "--disable-sdl",
            "--enable-motion_est",
            "--enable-gpl",
            "--enable-gpl3",
            "--enable-opencv"]

    args << "--disable-gtk2" if build.stable?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/melt", "-version"
  end
end
