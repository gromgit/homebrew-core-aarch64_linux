class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://angband.github.io/angband/"
  url "https://github.com/angband/angband/releases/download/4.2.4/Angband-4.2.4.tar.gz"
  sha256 "a07c78c1dd05e48ddbe4d8ef5d1880fcdeab55fd05f1336d9cba5dd110b15ff3"
  license "GPL-2.0-only"
  head "https://github.com/angband/angband.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/angband"
    sha256 aarch64_linux: "e460d2a4ce601946fed5a0c2e7a93c0d176d224a2b66f2cc7ce9e314e060142c"
  end

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config" if OS.mac?
    args = %W[
      --prefix=#{prefix}
      --bindir=#{bin}
      --libdir=#{libexec}
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
    ]
    args += "--with-ncurses-prefix=#{MacOS.sdk_path}/usr" if OS.mac?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"angband", "--help"
  end
end
