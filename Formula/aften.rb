class Aften < Formula
  desc "Audio encoder which generates ATSC A/52 compressed audio streams"
  homepage "https://aften.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/aften/aften/0.0.8/aften-0.0.8.tar.bz2"
  sha256 "87cc847233bb92fbd5bed49e2cdd6932bb58504aeaefbfd20ecfbeb9532f0c0a"
  license "LGPL-2.1-or-later"

  # Aften has moved from a version scheme like 0.07 to 0.0.8. We restrict
  # matching to versions with three parts, since a version like 0.07 is parsed
  # as 0.7 and seen as newer than 0.0.8.
  livecheck do
    url :stable
    regex(%r{url=.*?/aften[._-]v?(\d+(?:\.\d+){2,})\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aften"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f343c15ec89b6a437b83792cf46a9a4ba96ee61d9f71e556b1e8190d44349eff"
  end


  depends_on "cmake" => :build

  resource "sample_wav" do
    url "https://www.mediacollege.com/audio/tone/files/1kHz_44100Hz_16bit_05sec.wav"
    sha256 "949dd8ef74db1793ac6174b8d38b1c8e4c4e10fb3ffe7a15b4941fa0f1fbdc20"
  end

  # The ToT actually compiles fine, but there's no official release made from that changeset.
  # So fix the Apple Silicon compile issues.
  patch :DATA

  def install
    mkdir "default" do
      system "cmake", "-DSHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("sample_wav").stage testpath
    system "#{bin}/aften", "#{testpath}/1kHz_44100Hz_16bit_05sec.wav", "sample.ac3"
  end
end
__END__
From dca9c03930d669233258c114e914a01f7c0aeb05 Mon Sep 17 00:00:00 2001
From: jbr79 <jbr79@ef0d8562-5c19-0410-972e-841db63a069c>
Date: Wed, 24 Sep 2008 22:02:59 +0000
Subject: [PATCH] add fallback function for apply_simd_restrictions() on
 non-x86/ppc

git-svn-id: https://aften.svn.sourceforge.net/svnroot/aften@766 ef0d8562-5c19-0410-972e-841db63a069c
---
 libaften/cpu_caps.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libaften/cpu_caps.h b/libaften/cpu_caps.h
index b7c6159..4db11f7 100644
--- a/libaften/cpu_caps.h
+++ b/libaften/cpu_caps.h
@@ -26,6 +26,7 @@
 #include "ppc_cpu_caps.h"
 #else
 static inline void cpu_caps_detect(void){}
+static inline void apply_simd_restrictions(AftenSimdInstructions *simd_instructions){}
 #endif

 #endif /* CPU_CAPS_H */
--
2.24.3 (Apple Git-128)
