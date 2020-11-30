class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.6.tar.bz2"
  sha256 "87775d66a400e64a6c9866107c136355e67aec57e73b9e30137d0e46bf5fcfd8"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "3df4ca207535d9f89bb8329a2b47692fc88658994244af93b244bbcf4544160c" => :big_sur
    sha256 "092c548eb380707fb0ab8dcae46e235502013a34e9380f0716e831d6961919b7" => :catalina
    sha256 "169c6b528095d64e7a4918c27708e178b6bec88450438a9ab8a1dc0f3de7a580" => :mojave
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
