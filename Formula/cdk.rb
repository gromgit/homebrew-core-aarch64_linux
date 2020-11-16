class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20200923.tgz"
  sha256 "007f5de880cb2eebd8556df7e4cd8673d5e64c9970147eee6923a814c29faaed"

  livecheck do
    url "https://invisible-mirror.net/archives/cdk/"
    regex(/href=.*?cdk[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2a59be4bb0e53324aed2910deefb88dc58bd68c6d0dde48ebd8bd0ab864f00fa" => :big_sur
    sha256 "190c2dade7c968cd0dd25c15fa35ca5f152881a20e1839cecc0a2318ed7591d9" => :catalina
    sha256 "24a864dbf9b7755b0ea4679115d5e16973f11d1ff6142f9f74814ee197b8aae8" => :mojave
    sha256 "98c8cbbb106c156c8b782a20ee3cbb011ec7850f07a1a5d4b2006366fff1a4e6" => :high_sierra
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
