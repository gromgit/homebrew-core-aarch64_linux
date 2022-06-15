class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/1.2.15.tar.gz"
  sha256 "00037ab8d52772a95d645f1dcfd2c292b7cea326b54e63e219a5b7fdcb7e6508"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/zlog"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "759fa86a50d83c894dc9a672ee0a9d47696fe7056c867a0e93d453bbd5222757"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"zlog.conf").write <<~EOS
      [formats]
      simple = "%m%n"
      [rules]
      my_cat.DEBUG    >stdout; simple
    EOS
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <zlog.h>
      int main() {
        int rc;
        zlog_category_t *c;

        rc = zlog_init("zlog.conf");
        if (rc) {
          printf("init failed!");
          return -1;
        }

        c = zlog_get_category("my_cat");
        if (!c) {
          printf("get cat failed!");
          zlog_fini();
          return -2;
        }

        zlog_info(c, "hello, zlog!");
        zlog_fini();

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzlog", "-pthread", "-o", "test"
    assert_equal "hello, zlog!\n", shell_output("./test")
  end
end
