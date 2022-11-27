class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.9.1/imlib2-1.9.1.tar.gz"
  sha256 "c319292f5bcab33b91bffaa6f7b0842f9e2d1b90df6c9a2a39db4f24d538b35b"
  license "Imlib2"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/imlib2"
    sha256 aarch64_linux: "30a4ffa8edbe836f4211be6a30ceb79747769589700001cef2c9c6e8599f38e5"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"

  def install
    system "./configure", *std_configure_args, "--enable-amd64=no", "--without-id3"
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
