class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.3.tar.gz"
  sha256 "b7faab2fb9f46366a52b51443054a2ed4ecdd04774c65754bf807c5e9bdda477"
  license "ISC"
  revision 1
  head "https://github.com/atheme/libmowgli-2.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libmowgli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fa6e770cdb4e55ef6f7470f21bb1897b0a716295174029762ac93cd490acfc38"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mowgli.h>

      int main(int argc, char *argv[]) {
        char buf[65535];
        mowgli_random_t *r = mowgli_random_create();
        mowgli_formatter_format(buf, 65535, "%1! %2 %3 %4.",\
                    "sdpb", "Hello World", mowgli_random_int(r),\
                    0xDEADBEEF, TRUE);
        puts(buf);
        mowgli_object_unref(r);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-L#{lib}", "-lmowgli-2"
    system "./test"
  end
end
