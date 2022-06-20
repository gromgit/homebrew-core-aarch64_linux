class Less < Formula
  desc "Pager program similar to more"
  homepage "https://www.greenwoodsoftware.com/less/index.html"
  url "https://www.greenwoodsoftware.com/less/less-590.tar.gz"
  sha256 "6aadf54be8bf57d0e2999a3c5d67b1de63808bb90deb8f77b028eafae3a08e10"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/less[._-]v?(\d+(?:\.\d+)*).+?released.+?general use/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/less"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "492ef8ab378b1214ce5bb1568deb479ae16aef24beeef9b110ca82d5da21bf7a"
  end

  head do
    url "https://github.com/gwsw/less.git"
    depends_on "autoconf" => :build
    uses_from_macos "perl" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "make", "-f", "Makefile.aut", "distfiles" if build.head?
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre2"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
