class Hspell < Formula
  desc "Free Hebrew linguistic project"
  homepage "http://hspell.ivrix.org.il/"
  url "http://hspell.ivrix.org.il/hspell-1.4.tar.gz"
  sha256 "7310f5d58740d21d6d215c1179658602ef7da97a816bc1497c8764be97aabea3"
  license "AGPL-3.0-only"

  livecheck do
    url "http://hspell.ivrix.org.il/download.html"
    regex(/href=.*?hspell[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hspell"
    sha256 aarch64_linux: "fa00b434957e494f7c0af7238e1dbc080c830999c17fb23b5b1292bf2829d61c"
  end

  depends_on "autoconf" => :build

  uses_from_macos "zlib"

  # hspell was built for linux and compiles a .so shared library, to comply with macOS
  # standards this patch creates a .dylib instead
  patch :p0 do
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/hspell/1.3.patch"
      sha256 "63cc1bc753b1062d1144dcdd959a0a8f712b8872dce89e54ddff2d24f2ca2065"
    end
  end

  def install
    ENV.deparallelize

    # The build scripts rely on "." being in @INC which was disabled by default in perl 5.26
    ENV["PERL_USE_UNSAFE_INC"] = "1"

    # autoconf needs to pick up on the patched configure.in and create a new ./configure
    # script
    system "autoconf"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--enable-linginfo"
    system "make", "dolinginfo"
    system "make", "install"
  end

  test do
    File.open("test.txt", "w:ISO8859-8") do |f|
      f.write "שלום"
    end
    system "#{bin}/hspell", "-l", "test.txt"
  end
end
