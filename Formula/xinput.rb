class Xinput < Formula
  desc "Utility to configure and test X input devices"
  homepage "https://gitlab.freedesktop.org/xorg/app/xinput"
  url "https://www.x.org/pub/individual/app/xinput-1.6.3.tar.bz2"
  sha256 "35a281dd3b9b22ea85e39869bb7670ba78955d5fec17c6ef7165d61e5aeb66ed"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xinput"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3bfae7b3fafc6d9511af35e639192120ec71f641101e05bcd83f6e7b4ee31c1f"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxrandr"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate bin/"xinput", :exist?
    assert_equal %Q(.TH xinput 1 "xinput #{version}" "X Version 11"),
      shell_output("head -n 1 #{man1}/xinput.1").chomp
  end
end
