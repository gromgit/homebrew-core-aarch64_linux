class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-6.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-6.8.tar.xz"
  sha256 "8eb753ed28bca21f8f56c1a180362aed789229bd62fff58bf8368e9beb59fec4"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/texinfo"
    sha256 aarch64_linux: "5337150936a3942c980042d22c66c4ef9f3c304de8a0527e63b700973c8ba254"
  end


  keg_only :provided_by_macos

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match "Hello World!", File.read("test.info")
  end
end
