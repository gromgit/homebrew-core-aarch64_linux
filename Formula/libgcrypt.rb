class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.9.0.tar.bz2"
  sha256 "4d9ccaa5f99db59ebcb64d73f62825b05ce8a6b7f86d19178559ef84de1381cb"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/libgcrypt[._-]v?(\d+\.\d+\.\d+)/i)
  end

  bottle do
    cellar :any
    sha256 "95b397a91da34341ceff718abde87771be2616d240d6937bda7cffb66222fa0f" => :big_sur
    sha256 "a2309b77960d96cb14e3fd33f29a61d53357de52bf3bb92205d3e2d1923f042e" => :arm64_big_sur
    sha256 "6b3385316b48bd4b86e91317f125a715d0ecaf3ff4c2c15bc7eab3de70f29bf9" => :catalina
    sha256 "b3fbe8acbb01d243a7c40a0bfc2834ff0ff91064bf86a4d0e94a721285eb25d9" => :mojave
  end

  depends_on "libgpg-error"

  # Upstream patches to fix basic test failing
  # https://lists.gnupg.org/pipermail/gcrypt-devel/2021-January/005040.html
  # https://lists.gnupg.org/pipermail/gcrypt-devel/2021-January/005039.html
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--disable-jent-support" # Requires ENV.O0, which is unpleasant.

    # Parallel builds work, but only when run as separate steps
    system "make"
    on_macos do
      MachO.codesign!("#{buildpath}/tests/.libs/random") if Hardware::CPU.arm?
    end

    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libgcrypt-config", prefix, opt_prefix
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end

__END__
diff --git a/cipher/kdf.c b/cipher/kdf.c
index 3d707bd..93c2c9f 100644
--- a/cipher/kdf.c
+++ b/cipher/kdf.c
@@ -342,7 +342,7 @@ check_one (int algo, int hash_algo,
 static gpg_err_code_t
 selftest_pbkdf2 (int extended, selftest_report_func_t report)
 {
-  static struct {
+  static const struct {
     const char *desc;
     const char *p;   /* Passphrase.  */
     size_t plen;     /* Length of P. */
@@ -452,7 +452,8 @@ selftest_pbkdf2 (int extended, selftest_report_func_t report)
       "\x34\x8c\x89\xdb\xcb\xd3\x2b\x2f\x32\xd8\x14\xb8\x11\x6e\x84\xcf"
       "\x2b\x17\x34\x7e\xbc\x18\x00\x18\x1c\x4e\x2a\x1f\xb8\xdd\x53\xe1"
       "\xc6\x35\x51\x8c\x7d\xac\x47\xe9"
-    }
+    },
+    { NULL }
   };
   const char *what;
   const char *errtxt;
