class Cifer < Formula
  desc "Work on automating classical cipher cracking in C"
  homepage "https://code.google.com/p/cifer/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cifer/cifer-1.2.0.tar.gz"
  sha256 "436816c1f9112b8b80cf974596095648d60ffd47eca8eb91fdeb19d3538ea793"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cifer"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9d4f1ce9a3448f291d7af6cd34947502d4f81c28b641ca9d4189b3d6b0ce6167"
  end

  on_linux do
    depends_on "readline"

    # Fix order of linker flags for GCC
    patch :DATA
  end

  def install
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/cifer")
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -54,7 +54,7 @@ allfiles := $(wildcard *)
 all : cifer
 
 cifer : $(objects)
-	$(CC) $(CFLAGS) $(LINKLIBS) -o $@ $(objects)
+	$(CC) $(CFLAGS) -o $@ $(objects) $(LINKLIBS)
 
 src/%.o : src/%.c $(headers)
 	$(CC) $(DEFS) -c $(CFLAGS) $< -o $@
