class Rasqal < Formula
  desc "RDF query library"
  homepage "https://librdf.org/rasqal/"
  url "https://download.librdf.org/source/rasqal-0.9.33.tar.gz"
  sha256 "6924c9ac6570bd241a9669f83b467c728a322470bf34f4b2da4f69492ccfd97c"

  livecheck do
    url :homepage
    regex(/href=.*?rasqal[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rasqal"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "655cdc5300b0a33d02e5110fba4bbd33686bbe664e489314c4dfd7ada39985e5"
  end

  depends_on "pkg-config" => :build
  depends_on "raptor"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
