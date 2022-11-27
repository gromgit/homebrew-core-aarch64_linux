class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.22.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.22.4.tar.gz"
  sha256 "e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/groff"
    sha256 aarch64_linux: "c3a7655e69c3ec946f1e5e4c3af3622d62d1800595fa3abc8f1eb1cce9c55ae0"
  end

  depends_on "pkg-config" => :build
  depends_on "ghostscript"
  depends_on "netpbm"
  depends_on "psutils"
  depends_on "uchardet"

  uses_from_macos "bison" => :build
  uses_from_macos "texinfo" => :build
  uses_from_macos "perl"

  on_linux do
    depends_on "glib"
  end

  # See https://savannah.gnu.org/bugs/index.php?59276
  # Fixed in 1.23.0
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8059b3027a4aa68d8f42e1281cc3a81449ca0010/groff/1.22.4.patch"
    sha256 "aaea94b65169357a9a2c6e8f71dea35c87eed3e8f49aaa27003cd0893b54f7c4"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x", "--with-uchardet"
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n",
      pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end
