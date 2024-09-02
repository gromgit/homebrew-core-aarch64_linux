class HicolorIconTheme < Formula
  desc "Fallback theme for FreeDesktop.org icon themes"
  homepage "https://wiki.freedesktop.org/www/Software/icon-theme/"
  url "https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.17.tar.xz"
  sha256 "317484352271d18cbbcfac3868eab798d67fff1b8402e740baa6ff41d588a9d8"
  license all_of: ["FSFUL", "FSFULLR", "GPL-2.0-only", "X11"]

  livecheck do
    url :homepage
    regex(/href=.*?hicolor-icon-theme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hicolor-icon-theme"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6525db05b2d7b7870938e04b1d7700c229160081dcc218681b0e4172d620b88e"
  end

  head do
    url "https://gitlab.freedesktop.org/xdg/default-icon-theme.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-silent-rules]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    assert_predicate share/"icons/hicolor/index.theme", :exist?
  end
end
