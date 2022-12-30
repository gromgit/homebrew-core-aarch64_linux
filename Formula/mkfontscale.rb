class Mkfontscale < Formula
  desc "Create an index of scalable font files for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/mkfontscale-1.2.2.tar.xz"
  sha256 "8ae3fb5b1fe7436e1f565060acaa3e2918fe745b0e4979b5593968914fe2d5c4"
  license "X11"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/mkfontscale"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "93f85505d77e88b87cf12f29eddc10da459d37f3ff5a5299fd31342b24763f27"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"  => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    configure_args = std_configure_args + %w[
      --with-bzip2
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mkfontscale"
    assert_predicate testpath/"fonts.scale", :exist?
  end
end
