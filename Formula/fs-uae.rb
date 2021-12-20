class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/files/FS-UAE/Stable/3.1.66/fs-uae-3.1.66.tar.xz"
  sha256 "606e1868b500413d69bd33bb469f8fd08d6c08988801f17b7dd022f3fbe23832"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b972b6b29818a4b75882f429e98f8a9027712d7eb63fb63e9b4212dc050522c2"
    sha256 cellar: :any, arm64_big_sur:  "83168a16d8944aff930466fdf313c142a2b7952b842115b07a2b263c9a4491c3"
    sha256 cellar: :any, monterey:       "011dd714921118eb78308fbac4a231c895b7242ed50873e09d842463d3ea0202"
    sha256 cellar: :any, big_sur:        "3dedcfc5325c16c4c1070baf2eed8fd5ad8763ec47d921e376ecd54b746452e1"
    sha256 cellar: :any, catalina:       "b0c73c09f5f798a6cfc1f34eb8c84c76e1c4da4a69cfc49d0f7afcd6e511c44d"
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "sdl2"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
