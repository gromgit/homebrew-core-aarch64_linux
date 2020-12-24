class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/image/PC6001VX_3.6.0_src.tar.gz"
  sha256 "5c67c4d392c399e98c65bcd8518b0cf92551813f70357c41403b100981c1d4e8"
  license "LGPL-2.1-or-later"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "797502f1a69d1f76daca1f4f826939a31abf5873e2ca5bbd8a21d0c4c2ada9f1" => :big_sur
    sha256 "0c5ead68bc33614a935dc50639f6a836d12c56733970141ca602e043494d7d96" => :catalina
    sha256 "ea31ddd766c35c14ef13191c987edae64b8b629773dcd4db32dd5deacd5365b2" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "qt"
  depends_on "sdl2"

  def install
    # Need to explicitly set up include directories
    ENV.append_to_cflags "-I#{Formula["sdl2"].opt_include}"
    ENV.append_to_cflags "-I#{Formula["ffmpeg"].opt_include}"
    # Turn off errors on C++11 build which used for properly linking standard lib
    ENV.append_to_cflags "-Wno-reserved-user-defined-literal"
    # Use libc++ explicitly, otherwise build fails
    ENV.append_to_cflags "-stdlib=libc++" if ENV.compiler == :clang

    system "qmake", "PREFIX=#{prefix}", "QMAKE_CXXFLAGS=#{ENV.cxxflags}", "CONFIG+=c++11"
    system "make"
    prefix.install "PC6001VX.app"
    bin.write_exec_script "#{prefix}/PC6001VX.app/Contents/MacOS/PC6001VX"
  end
end
