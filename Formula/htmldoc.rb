class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.15.tar.gz"
  sha256 "9dc88e5a2ce849105933c438bbe54f4383f0d1dadb494f52c6ec941317659431"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/htmldoc"
    sha256 aarch64_linux: "5bc88f1b638183c353b63b024d6746f9857237ec3049742587889e8c34030564"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
