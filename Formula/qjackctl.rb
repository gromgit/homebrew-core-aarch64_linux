class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/qjackctl/qjackctl-0.6.3.tar.gz"
  sha256 "9db46376cfacb2e2ee051312245f5f7c383c9f5a958c0e3d661b9bd2a9246b7d"
  license "GPL-2.0"
  head "https://git.code.sf.net/p/qjackctl/code.git"

  bottle do
    sha256 "8598422d0a0c13a9328e188f91237075aa564f5d8b41579b610e61f475b6023c" => :catalina
    sha256 "2b10cef277e90fe3e7342efc529e52ff54d9236448dfb09bf49d3f1aa79951eb" => :mojave
    sha256 "ab701ff3dadb5e7adae195e49169bfe9e51a47e7d9ab48cfa6f97e3db24cd7f0" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt"

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt=#{Formula["qt"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
