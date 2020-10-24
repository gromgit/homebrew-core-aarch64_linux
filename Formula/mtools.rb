class Mtools < Formula
  desc "Tools for manipulating MSDOS files"
  homepage "https://www.gnu.org/software/mtools/"
  url "https://ftp.gnu.org/gnu/mtools/mtools-4.0.25.tar.gz"
  mirror "https://ftpmirror.gnu.org/mtools/mtools-4.0.25.tar.gz"
  sha256 "8b6d4a75122984350186250aaa6063665bfa69100253fd77b972d2744e07dc08"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a5229fbfcd666abf4c79cd065be6a58801228460f999319a0234319ccb8aba3a" => :catalina
    sha256 "3a9d80e7a7e9a6dd377d0030a5fbc29e509ca6dd598e24943b36169ed1512670" => :mojave
    sha256 "ebed9be10002c3a8a68089ff43702b24f1f2c451be9e14778eaece3ad4e0cdc0" => :high_sierra
  end

  conflicts_with "multimarkdown", because: "both install `mmd` binaries"

  # 4.0.25 doesn't include the proper osx locale headers.
  patch :DATA

  def install
    args = %W[
      LIBS=-liconv
      --disable-debug
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --without-x
    ]

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/mtools --version")
  end
end

__END__
diff --git a/sysincludes.h b/sysincludes.h
index 056218e..ba3677b 100644
--- a/sysincludes.h
+++ b/sysincludes.h
@@ -279,6 +279,8 @@ extern int errno;
 #include <pwd.h>
 #endif
 
+#include <xlocale.h>
+#include <strings.h>
 
 #ifdef HAVE_STRING_H
 # include <string.h>

