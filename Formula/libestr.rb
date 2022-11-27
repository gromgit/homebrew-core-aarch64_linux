class Libestr < Formula
  desc "C library for string handling (and a bit more)"
  homepage "https://libestr.adiscon.com/"
  url "https://libestr.adiscon.com/files/download/libestr-0.1.11.tar.gz"
  sha256 "46632b2785ff4a231dcf241eeb0dcb5fc0c7d4da8ee49cf5687722cdbe8b2024"
  license "LGPL-2.1"

  livecheck do
    url "https://libestr.adiscon.com/download/"
    regex(/href=.*?libestr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libestr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3c9bb83471b2d084130797eb1ae48b0f08e111465591d6b2b7238a59a3386cf8"
  end

  depends_on "pkg-config" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "stdio.h"
      #include <libestr.h>
      int main() {
        printf("%s\\n", es_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lestr", "-o", "test"
    system "./test"
  end
end
