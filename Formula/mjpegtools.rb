class Mjpegtools < Formula
  desc "Record and playback videos and perform simple edits"
  homepage "https://mjpeg.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mjpeg/mjpegtools/2.2.1/mjpegtools-2.2.1.tar.gz"
  sha256 "b180536d7d9960b05e0023a197b00dcb100929a49aab71d19d55f4a1b210f49a"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mjpegtools"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a0b521edcf01feab599c689f6e5f4185c3ac7af67d8a0994fd7a5de8b1fe742e"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-simd-accel",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
