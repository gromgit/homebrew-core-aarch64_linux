class Libxau < Formula
  desc "X.Org: A Sample Authorization Protocol for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXau-1.0.10.tar.xz"
  sha256 "8be6f292334d2f87e5b919c001e149a9fdc27005d6b3e053862ac6ebbf1a0c0a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libxau"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "67a818014de01b3ea3b5955b06711c4a31831c3ffd2c775cf3333a9d88882de0"
  end


  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto"

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
    (testpath/"test.c").write <<~EOS
      #include "X11/Xauth.h"

      int main(int argc, char* argv[]) {
        Xauth auth;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
