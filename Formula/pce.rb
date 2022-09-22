class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
  sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
  revision 3
  head "git://git.hampa.ch/pce.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e91060cfda85a63fee4413b7eb726714f8775e0cd452edd0957eba43c578fdd4"
    sha256 cellar: :any, arm64_big_sur:  "a549787c54e01ed779ac141bf523bca16b00151802f77fa869c2f2d660dc2732"
    sha256 cellar: :any, monterey:       "a393cdc7dadc636acfe2f16510d4422ffd2a9fa565c094e8b82c26a7c4574456"
    sha256 cellar: :any, big_sur:        "84d3de8d69880534cd5a1daa04370df793e7cd81ea4c97d7146c567e904a9c28"
    sha256 cellar: :any, catalina:       "2d003611fb1b523196faccd42360b38a5ef955ba9a5accf213270381499c00d7"
  end

  depends_on "readline"
  depends_on "sdl12-compat"

  on_high_sierra :or_newer do
    depends_on "nasm" => :build
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--enable-readline"
    system "make"

    # We need to run 'make install' without parallelization, because
    # of a race that may cause the 'install' utility to fail when
    # two instances concurrently create the same parent directories.
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/pce-ibmpc", "-V"
  end
end
