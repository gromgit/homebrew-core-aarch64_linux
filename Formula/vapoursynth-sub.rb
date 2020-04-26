class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "http://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/R49.tar.gz"
  sha256 "126d1e68d3a3e80d1e215c8a2a5dc8773f5fcac70a6c22dadc837bccb603bccd"
  revision 1
  head "https://github.com/vapoursynth/vapoursynth.git"

  bottle do
    cellar :any
    sha256 "312e88c9ca46369ec77c933aec797fb8fe55de9577882e5920abeac194e5c08b" => :catalina
    sha256 "f17e990bd39f162b5c5a1810e2a35ee203c1fb54636228a25aa545bb7a5930d6" => :mojave
    sha256 "f49ca753071f7cb66ca358f62afa58dcb8f41d73ba69d407460ae0b55e4d1a84" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  def install
    system "./autogen.sh"
    inreplace "Makefile.in", "pkglibdir = $(libdir)", "pkglibdir = $(exec_prefix)"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-core",
                          "--disable-vsscript",
                          "--disable-plugins",
                          "--enable-subtext"
    system "make", "install"
    rm prefix/"vapoursynth/libsubtext.la"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/vapoursynth").mkpath
    (HOMEBREW_PREFIX/"lib/vapoursynth").install_symlink prefix/"vapoursynth/libsubtext.dylib" => "libsubtext.dylib"
  end

  test do
    xy = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", lib/"python#{xy}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "-c", "from vapoursynth import core; core.sub"
  end
end
