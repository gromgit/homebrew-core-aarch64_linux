class Sword < Formula
  desc "Cross-platform tools to write Bible software"
  homepage "https://www.crosswire.org/sword/index.jsp"
  url "https://www.crosswire.org/ftpmirror/pub/sword/source/v1.9/sword-1.9.0.tar.gz"
  sha256 "42409cf3de2faf1108523e2c5ac0745d21f9ed2a5c78ed878ee9dcc303426b8a"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.crosswire.org/ftpmirror/pub/sword/source/"
    regex(%r{href=.*?sword[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sword"
    sha256 aarch64_linux: "4b276c553d85f64b2a5ef7669faa5342b087e2fff36afc0e54563d239da2ddfa"
  end

  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-profile
      --disable-tests
      --with-curl
      --without-icu
      --without-clucene
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    # This will call sword's module manager to list remote sources.
    # It should just demonstrate that the lib was correctly installed
    # and can be used by frontends like installmgr.
    system "#{bin}/installmgr", "-s"
  end
end
