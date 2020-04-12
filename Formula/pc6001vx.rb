class Pc6001vx < Formula
  desc "PC-6001 emulator"
  homepage "https://eighttails.seesaa.net/"
  url "https://eighttails.up.seesaa.net/bin/PC6001VX_3.4.0_src.tar.gz"
  sha256 "4149b4c4a53d002748b7ad6c06a2e0d967ce8a72c6d14e06672df4eb1d968044"
  head "https://github.com/eighttails/PC6001VX.git"

  bottle do
    cellar :any
    sha256 "6d79315d4f41941bd35f8f9452b91aae330f19d1f1e843d19a7aa4b063fab235" => :catalina
    sha256 "725e10f29d21fb556d51b61b988433e6524164918270c7c4321df5866a485162" => :mojave
    sha256 "7ece9b228973e43ae606c210e608aac6a4779cb49fb72ffe7d817f18f93c1ca7" => :high_sierra
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
