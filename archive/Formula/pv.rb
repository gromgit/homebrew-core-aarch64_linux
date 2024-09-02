class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.6.20.tar.bz2"
  sha256 "e831951eff0718fba9b1ef286128773b9d0e723e1fbfae88d5a3188814fdc603"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pv"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "667447650bc26b40b0551df1779534afb46bd8844ac0c71cae9ad408b459426e"
  end

  # Patch for macOS 11 on Apple Silicon support. Emailed to the maintainer in January 2021.
  # There is no upstream issue tracker or public mailing list.
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-nls"
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip
  end
end
__END__
diff --git a/src/include/pv-internal.h b/src/include/pv-internal.h
index db65eaa..176fc86 100644
--- a/src/include/pv-internal.h
+++ b/src/include/pv-internal.h
@@ -18,6 +18,14 @@
 #include <sys/time.h>
 #include <sys/stat.h>

+// Since macOS 10.6, stat64 variants are equivalent to plain stat, and the
+// suffixed versions have been removed in macOS 11 on Apple Silicon. See stat(2).
+#ifdef __APPLE__
+#define stat64 stat
+#define fstat64 fstat
+#define lstat64 lstat
+#endif
+
 #ifdef __cplusplus
 extern "C" {
 #endif
