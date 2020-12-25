class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.10.1.tar.gz"
  sha256 "5bf0bbc555cb6059008f1b748370d4d2ee1e1fabd3eeab68475263556405ba39"
  license any_of: ["GPL-3.0", "MIT"]
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "8af3feb84f80d88ac047cb3719bdd44ba36569a46fbc631841557f18018e21d4" => :big_sur
    sha256 "9d02ccf101797f9d37ad709c6827bde93b06a356f94d50c57290b25cb917d7d6" => :catalina
    sha256 "b85ddffb34d325b02d9d401892446b269300bc3ba2e170b14cb6c50576070d4a" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@1.1"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <strophe.h>
      #include <assert.h>

      int main(void) {
        xmpp_ctx_t *ctx;
        xmpp_log_t *log;

        xmpp_initialize();
        log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG);
        assert(log);

        ctx = xmpp_ctx_new(NULL, log);
        assert(ctx);

        xmpp_ctx_free(ctx);
        xmpp_shutdown();
        return 0;
      }
    EOS
    flags = ["-I#{include}/", "-L#{lib}", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
