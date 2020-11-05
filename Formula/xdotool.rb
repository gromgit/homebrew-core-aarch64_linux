class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/v3.20160805.1.tar.gz"
  sha256 "ddafca1239075c203769c17a5a184587731e56fbe0438c09d08f8af1704e117a"
  revision 2

  bottle do
    sha256 "7092970eee9f15fab6aad9e364cb23b29f11fc19b1edbedd3ac794a7858aecc5" => :catalina
    sha256 "0a24fe2911c4db734794e7c22c596a9809602af3d974abe2aae2f6ef9babb777" => :mojave
    sha256 "9e84711dc1979c07a5367c2a2638e07e01f9bb7b8fb5166b4d1cadaed6babb7b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxtst"

  def install
    # Work around an issue with Xcode 8 on El Capitan, which
    # errors out with `typedef redefinition with different types`
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats
    <<~EOS
      You will probably want to enable XTEST in your X11 server now by running:
        defaults write org.x.X11 enable_test_extensions -boolean true

      For the source of this useful hint:
        https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end
