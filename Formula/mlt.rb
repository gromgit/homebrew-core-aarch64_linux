class Mlt < Formula
  desc "Author, manage, and run multitrack audio/video compositions"
  homepage "https://www.mltframework.org/"
  url "https://github.com/mltframework/mlt/releases/download/v6.26.0/mlt-6.26.0.tar.gz"
  sha256 "06da1d4f82bcb18116ee9b0dd5252c080c181b91442cbe5783a2f3bdfd550f38"
  license "LGPL-2.1-only"
  head "https://github.com/mltframework/mlt.git"

  bottle do
    sha256 big_sur:  "5f7ce6e78b706afbbf416f7f21764e452acdf19321025e6d2276df85bc30d127"
    sha256 catalina: "69ad1e141b078fa1273906f3c2f7b1395252ced7285e31af28d66460658b6695"
    sha256 mojave:   "af2b1432a879a371ff539ffa694b362aef19bd907c31594c045e59f9fb804d0c"
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
  depends_on "opencv@3"
  depends_on "pango"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "sox"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-jackrack",
            "--disable-swfdec",
            "--disable-sdl",
            "--enable-motion_est",
            "--enable-gpl",
            "--enable-gpl3",
            "--enable-opencv"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "help", shell_output("#{bin}/melt -help")
  end
end
