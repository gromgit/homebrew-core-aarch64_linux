class Jimtcl < Formula
  desc "Small footprint implementation of Tcl"
  homepage "http://jim.tcl.tk/index.html"
  url "https://github.com/msteveb/jimtcl/archive/0.81.tar.gz"
  sha256 "ab7eb3680ba0d16f4a9eb1e05b7fcbb7d23438e25185462c55cd032a1954a985"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jimtcl"
    sha256 aarch64_linux: "88c70bc2058f50d399b4b2243c235c6ca8719977ad083d99e3e266fa86e2e865"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--full",
                          "--with-ext=readline,rlprompt,sqlite3",
                          "--shared",
                          "--docdir=#{doc}",
                          "--maintainer",
                          "--math",
                          "--ssl",
                          "--utf8"
    system "make"
    system "make", "install"
    pkgshare.install Dir["examples*"]
  end

  test do
    (testpath/"test.tcl").write "puts {Hello world}"
    assert_match "Hello world", shell_output("#{bin}/jimsh test.tcl")
  end
end
