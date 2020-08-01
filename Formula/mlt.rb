class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  license "LGPL-2.1"

  stable do
    url "https://github.com/mltframework/mlt/archive/v6.22.0.tar.gz"
    sha256 "3392d70c528d7f32e78329232b1b93a5a36b058215f664953090315132b797e5"

    depends_on "opencv@3"
  end

  bottle do
    sha256 "ba79a7fdec91b58e1d53ab88b6d970215b11c33d758a931fa24a9035ff9a3e5f" => :catalina
    sha256 "a8f1cd443ea52e7640f19d0b814ab22eeae837690463f44f449add99357cdbeb" => :mojave
    sha256 "e33d6c696dc158d47e53ee9eb92d4171c0e2c034ffac41fff33f3ef111a993a4" => :high_sierra
  end

  head do
    url "https://github.com/mltframework/mlt.git"

    depends_on "opencv"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "frei0r"
  depends_on "gdk-pixbuf"
  depends_on "libdv"
  depends_on "libexif"
  depends_on "libsamplerate"
  depends_on "libvorbis"
  depends_on "pango"
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
