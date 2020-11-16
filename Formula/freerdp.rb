class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  url "https://github.com/FreeRDP/FreeRDP/archive/2.2.0.tar.gz"
  sha256 "883bc0396c6be9aba6bc07ebc8ff08457125868ada0f06554e62ef072f90cf59"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 "9ce96071c6b5669d95af69ae583c6ae15ba3c9d52597d0eacbb967386c7461cc" => :big_sur
    sha256 "500faf5c949356095126fc08fd1f5bd71ee2254cdb7f65e7ac38cbfde151911d" => :catalina
    sha256 "a97258802689aebfb320f3649a9fa36389c885953afb211f9b54962eec8a87f7" => :mojave
    sha256 "8c95c86605b16b6a524b720f70c783c9a77e50719d49cd02a0624da03e4cf92d" => :high_sierra
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on xcode: :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxrandr"
  depends_on "libxrender"
  depends_on "libxv"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "alsa-lib"
    depends_on "ffmpeg"
    depends_on "glib"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DWITH_X11=ON", "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"
  end

  test do
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp" if !success && details.exitstatus != 128
  end
end
