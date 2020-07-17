class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.15.0/fswatch-1.15.0.tar.gz"
  sha256 "26b4a002dc9c5f0a5a7605e2d9c60588ea338c077fccfa4473d2b9b8b8bb6f06"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "3717cd4f32abd016ff688eb29c6edcb1558b0717b0ff4ede6c3480c245c237e2" => :catalina
    sha256 "7310f4dbbbdeed582cb713b3d08bf982553747cbda75eb76d2dfe00f309ed3f7" => :mojave
    sha256 "68cfeb10ae04d00cc90e0d87d48a61c7c22b38f386410dbf2eb6c004200ddc8a" => :high_sierra
    sha256 "9362bc3b3321bf0238fa70d2f2825e4118e18deb2207af3a2633b6772bb33666" => :sierra
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
