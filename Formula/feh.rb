class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.4.tar.bz2"
  sha256 "18545ca5c7537268810bec564db9cd3ad1ca98c2a2f23ec243d3bac56cfc0365"

  bottle do
    sha256 "243213f9dda328512d1f9edb33acb3d4a270d84ee56d94404a697d5d109a8946" => :catalina
    sha256 "182c119d7b0d6b050b56f1dff8eb760a3d7c4ad9d2376598dd29a0539123e195" => :mojave
    sha256 "0d9ef02cfe0582e2289b1ef2255ad8a6535c91ccfeb1f57849463a020714be92" => :high_sierra
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on :x11

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
