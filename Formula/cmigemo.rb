class Cmigemo < Formula
  desc "Migemo is a tool that supports Japanese incremental search with Romaji"
  homepage "https://www.kaoriya.net/software/cmigemo"
  license "MIT"
  head "https://github.com/koron/cmigemo.git", branch: "master"

  stable do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cmigemo/cmigemo-default-src-20110227.zip"
    sha256 "4aa759b2e055ef3c3fbeb9e92f7f0aacc1fd1f8602fdd2f122719793ee14414c"

    # Patch per discussion at: https://github.com/Homebrew/legacy-homebrew/pull/7005
    patch :DATA
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cmigemo"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "99b1d8f87828d04456a565dd925f56c66da82a5a46ca63b60f48aed38475733f"
  end

  depends_on "nkf" => :build

  def install
    chmod 0755, "./configure"
    system "./configure", "--prefix=#{prefix}"
    os = if OS.mac?
      "osx"
    else
      "gcc"
    end
    system "make", os
    system "make", "#{os}-dict"
    system "make", "-C", "dict", "utf-8" if build.stable?
    ENV.deparallelize # Install can fail on multi-core machines unless serialized
    system "make", "#{os}-install"
  end

  def caveats
    <<~EOS
      See also https://github.com/emacs-jp/migemo to use cmigemo with Emacs.
      You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end

__END__
--- a/src/wordbuf.c	2011-08-15 02:57:05.000000000 +0900
+++ b/src/wordbuf.c	2011-08-15 02:57:17.000000000 +0900
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include "wordbuf.h"

 #define WORDLEN_DEF 64
