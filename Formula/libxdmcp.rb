class Libxdmcp < Formula
  desc "X.Org: X Display Manager Control Protocol library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdmcp-1.1.3.tar.bz2"
  sha256 "20523b44aaa513e17c009e873ad7bbc301507a3224c232610ce2e099011c6529"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxdmcp"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "955834b05a4c426e2bc557875e10d875a4ab3112ce4e7de9f450d96c68839e9e"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xdmcp.h"

      int main(int argc, char* argv[]) {
        xdmOpCode code;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
