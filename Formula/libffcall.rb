class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftp.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  sha256 "8ef69921dbdc06bc5bb90513622637a7b83a71f31f5ba377be9d8fd8f57912c2"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libffcall"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "20b1e79fa4bf62eaf7d56c45c13930314ee20b7c947317493eb2fa9758870e20"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"callback.c").write <<~EOS
      #include <stdio.h>
      #include <callback.h>

      typedef char (*char_func_t) ();

      void function (void *data, va_alist alist)
      {
        va_start_char(alist);
        va_return_char(alist, *(char *)data);
      }

      int main() {
        char *data = "abc";
        callback_t callback = alloc_callback(&function, data);
        printf("%s\\n%c\\n",
          is_callback(callback) ? "true" : "false",
          ((char_func_t)callback)());
        free_callback(callback);
        return 0;
      }
    EOS
    flags = ["-L#{lib}", "-lffcall", "-I#{lib}/libffcall-#{version}/include"]
    system ENV.cc, "-o", "callback", "callback.c", *(flags + ENV.cflags.to_s.split)
    output = shell_output("#{testpath}/callback")
    assert_equal "true\na\n", output
  end
end
