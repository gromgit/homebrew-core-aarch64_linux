class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/0.9.5/qjackctl-0.9.5.tar.gz"
  sha256 "3b9b15cafc6b61540596240db216c59338e6e4a1fb9042a0a5bc59dd35efc1bc"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "1b46db8481b0aec95ed530f94dda8f984aaf81ff99d5b968a4e030bcc711a51e"
    sha256 arm64_big_sur:  "1b46db8481b0aec95ed530f94dda8f984aaf81ff99d5b968a4e030bcc711a51e"
    sha256 big_sur:        "d8f854c69cbedb599a259ce77293e8bbb287ac2e3885c1ce4962be12aa49c6d9"
    sha256 catalina:       "f6ed6c17172898b5b6899835a1fabf88e2f667602efa9741c3ad9558ce179aba"
  end

  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt@5"

  # Patch the build, remove in next release
  patch do
    url "https://github.com/rncbc/qjackctl/commit/86c482fcdae2612dac7370296c58b9bcb3b134d1.patch?full_index=1"
    sha256 "dd3cdd6f21322a18012da8934000419819d8366477ce8a2bcdf49de82e6d7f51"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-debug",
                          "--disable-dbus",
                          "--disable-portaudio",
                          "--disable-xunique",
                          "--prefix=#{prefix}",
                          "--with-jack=#{Formula["jack"].opt_prefix}",
                          "--with-qt=#{Formula["qt@5"].opt_prefix}"

    system "make", "install"
    prefix.install bin/"qjackctl.app"
    bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1", 1)
  end
end
