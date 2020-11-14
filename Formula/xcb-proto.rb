class XcbProto < Formula
  desc "X.Org: XML-XCB protocol descriptions for libxcb code generation"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/xcb-proto-1.14.tar.gz"
  sha256 "1c3fa23d091fb5e4f1e9bf145a902161cec00d260fabf880a7a248b02ab27031"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "25981c40536a924beb9c3a21b95367ef489185ded08031e635472510408d110f" => :big_sur
    sha256 "c32a3d3a2fac9a68d5dafe02a75300c05beaa3151f1fbfafad5e718ce26e1553" => :catalina
    sha256 "e6faf01ae0757a6f2f49f05fb2262a36d0d39f61687b710cbfe368829856b0f2" => :mojave
    sha256 "de7af3536a1c9a33bd74567f22200e66a6541933506aec0dff275c490109d539" => :high_sierra
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      PYTHON=python3
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "#{share}/xcb", shell_output("pkg-config --variable=xcbincludedir xcb-proto").chomp
  end
end
