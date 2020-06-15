class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.5.1_src.tar.gz"
  sha256 "03b9f391d1c3725d2e1bfb33ae17a20217a32d1980d8540f3952cdb28f42e39e"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "1fa94882fec9ab891e042efe0d0d7dca4714cfb16621dc01bd866b4b94f7b865" => :catalina
    sha256 "18b503e1b9dd04d409e43f26e66a4d949ad96b03673037dcfda19879069c86a1" => :mojave
    sha256 "fe8927bba818b54bbdc80aded58ea812c9c7718fcca357e446705ad658cc8ac2" => :high_sierra
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
