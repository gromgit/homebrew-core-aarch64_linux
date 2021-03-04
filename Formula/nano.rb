class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.6.1.tar.xz"
  sha256 "760d7059e0881ca0ee7e2a33b09d999ec456ff7204df86bee58eb6f523ee8b09"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "7a7e173f0395b6a45541b07483132c39937d2e4865452f98abb4884c3ac992eb"
    sha256 big_sur:       "ba510688137e47fc5368278100162b66a42b62b8082853c720d053cbb7d80cc8"
    sha256 catalina:      "0131a43c34d8689fd71c7b23c5954713808f8f752800d6b4e19c817c6af2f66f"
    sha256 mojave:        "c4f24cec046e342c6c1e2e46beb1605e6d6e2d26a37dcd8377cb6250eb4f9274"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
