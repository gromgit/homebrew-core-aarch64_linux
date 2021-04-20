class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.9.3.tar.bz2"
  sha256 "97ebe4f94e2f7e35b752194ce15a0f3c66324e0ff6af26659bbfb5ff2ec328fd"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/href=.*?libgcrypt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "65279a10d89457614d2302e2d89fed3c1fa9cdc69a8fe7c2f4c4d48d6d375def"
    sha256 cellar: :any, big_sur:       "54c3d59311aea6eff9d5a313243d5dd037f17d936a14e3fe707828f4e06de389"
    sha256 cellar: :any, catalina:      "7b62e5158ca2910802dbd6a478bac6679b1a967ec7739a80018ae0069fcb2468"
    sha256 cellar: :any, mojave:        "dcd2fb732dcf01ba32dea8f5e0d739ccfdd39ed2734520c985c73dff81b8cb8c"
  end

  depends_on "libgpg-error"

  # Fix --disable-asm build on Intel. https://dev.gnupg.org/T5277
  # Reverts https://dev.gnupg.org/rC8d404a629167d67ed56e45de3e65d1e0b7cdeb24
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
diff --git a/src/g10lib.h b/src/g10lib.h
index 243997e..1987265 100644
--- a/src/g10lib.h
+++ b/src/g10lib.h
@@ -217,7 +217,6 @@ char **_gcry_strtokenize (const char *string, const char *delim);
 
 
 /*-- src/hwfeatures.c --*/
-#if defined(HAVE_CPU_ARCH_X86)
 
 #define HWF_PADLOCK_RNG         (1 << 0)
 #define HWF_PADLOCK_AES         (1 << 1)
@@ -238,29 +237,21 @@ char **_gcry_strtokenize (const char *string, const char *delim);
 #define HWF_INTEL_RDTSC         (1 << 15)
 #define HWF_INTEL_SHAEXT        (1 << 16)
 
-#elif defined(HAVE_CPU_ARCH_ARM)
-
 #define HWF_ARM_NEON            (1 << 0)
 #define HWF_ARM_AES             (1 << 1)
 #define HWF_ARM_SHA1            (1 << 2)
 #define HWF_ARM_SHA2            (1 << 3)
 #define HWF_ARM_PMULL           (1 << 4)
 
-#elif defined(HAVE_CPU_ARCH_PPC)
-
 #define HWF_PPC_VCRYPTO         (1 << 0)
 #define HWF_PPC_ARCH_3_00       (1 << 1)
 #define HWF_PPC_ARCH_2_07       (1 << 2)
 
-#elif defined(HAVE_CPU_ARCH_S390X)
-
 #define HWF_S390X_MSA           (1 << 0)
 #define HWF_S390X_MSA_4         (1 << 1)
 #define HWF_S390X_MSA_8         (1 << 2)
 #define HWF_S390X_VX            (1 << 3)
 
-#endif
-
 gpg_err_code_t _gcry_disable_hw_feature (const char *name);
 void _gcry_detect_hw_features (void);
 unsigned int _gcry_get_hw_features (void);
