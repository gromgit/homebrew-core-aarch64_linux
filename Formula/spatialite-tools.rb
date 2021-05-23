class SpatialiteTools < Formula
  desc "CLI tools supporting SpatiaLite"
  homepage "https://www.gaia-gis.it/fossil/spatialite-tools/index"
  url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-5.0.1.tar.gz"
  sha256 "9604c205e87f037789bc52302c66ccd1371c3e98c74e8ec4e29b0752de35171c"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/"
    regex(/href=.*?spatialite-tools[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "325038bba5d939af5d5cd61f331fe5c89891297ac0f39e3bf8009167ec0a07ef"
    sha256 cellar: :any, big_sur:       "a3b4c688705cb239e39c6c93c22632416b1293482ef4776406289cd45c24b05e"
    sha256 cellar: :any, catalina:      "cf9be33943b4f2345affe2d2ff3160b68c67802f9e830fd4e2cc15b9598375dd"
    sha256 cellar: :any, mojave:        "241d0932835ccab169ed2a67e9f51145561701038b3ab715e8a3b29b12d88f7a"
  end

  depends_on "pkg-config" => :build
  depends_on "libspatialite"
  depends_on "proj@7"
  depends_on "readosm"

  def install
    # See: https://github.com/Homebrew/homebrew/issues/3328
    ENV.append "LDFLAGS", "-liconv"
    # Ensure Homebrew SQLite is found before system SQLite.
    #
    # spatialite-tools picks `proj` (instead of `proj@7`) if installed
    sqlite = Formula["sqlite"]
    proj = Formula["proj@7"]
    ENV.prepend "LDFLAGS", "-L#{sqlite.opt_lib} -lsqlite3 -L#{proj.opt_lib}"
    ENV.prepend "CFLAGS", "-I#{sqlite.opt_include} -I#{proj.opt_include}"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"spatialite", "--version"
  end
end
