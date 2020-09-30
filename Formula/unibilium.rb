class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/v2.1.0.tar.gz"
  sha256 "05bf97e357615e218126f7ac086e7056a23dc013cfac71643b50a18ad390c7d4"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "f0c90f1197382f36f1cc4629c625c04a434e5daa91db0c6f2336cb26c1f932a0" => :big_sur
    sha256 "fb0335f25d2848a8dc1eb0911292905c76bb97e98bf349fc6afefe7752164fd1" => :catalina
    sha256 "3886afa29fecdbf2051ae6a92fac638bd27b6edafb75b199e50c0fc6fbf18266" => :mojave
    sha256 "5c29d645cd3e0ad950a7054c73b89cb76114b369476eb8bca26587c38571861d" => :high_sierra
    sha256 "15338d452e5e09e7b8f3bedd6d557d735d06bfbc53204487d11b6c225a04ad71" => :sierra
    sha256 "d8caea872f5f8ed11503e46fc37f17fafbc8a4c64a5382e2bf9e6d84feda2f98" => :el_capitan
  end

  depends_on "libtool" => :build

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unibilium.h>
      #include <stdio.h>

      int main()
      {
        setvbuf(stdout, NULL, _IOLBF, 0);
        unibi_term *ut = unibi_dummy();
        unibi_destroy(ut);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunibilium", "-o", "test"
    system "./test"
  end
end
