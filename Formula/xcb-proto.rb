class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.15.2.tar.xz"
  sha256 "7072beb1f680a2fe3f9e535b797c146d22528990c72f63ddb49d2f350a3653ed"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/xcb-proto"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "34a98d61fb41dca2c313ea7ea2384a288446363bc2f3221d443674d57419fcfd"
  end


  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.10" => :build

  def install
    python = "python3.10"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      PYTHON=#{python}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
  end
end
