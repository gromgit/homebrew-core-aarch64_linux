class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.1.tar.xz"
  sha256 "9efc46f341404d60095d16fc4f0419fc84b6e4eaeaf6ebce605d0465d92a6ee6"
  license "GPL-3.0"

  bottle do
    sha256 "364da878cbe90e6e09be7cfd252f01e55cdf787bf013530cba2d94e437eaffb1" => :catalina
    sha256 "7f7103bf8eb1d02d370f574a030a84a231356688314d182b63cc21a72999dfcc" => :mojave
    sha256 "6684387d3aed8f58a0205a04db2162c6d2b95ff1d09e7438df4299eefabbadf0" => :high_sierra
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
