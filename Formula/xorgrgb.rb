class Xorgrgb < Formula
  desc "X.Org: color names database"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/app/rgb-1.0.6.tar.bz2"
  sha256 "bbca7c6aa59939b9f6a0fb9fff15dfd62176420ffd4ae30c8d92a6a125fbe6b0"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xorgrgb"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5848fea1152f4902525d45c1f4738cdf6ff04412a82b5a678022cfcaac906010"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "gray100", shell_output("#{bin}/showrgb").chomp
  end
end
