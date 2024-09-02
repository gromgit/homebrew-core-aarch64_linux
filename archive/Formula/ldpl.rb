class Ldpl < Formula
  desc "Compiled programming language inspired by COBOL"
  homepage "https://www.ldpl-lang.org/"
  url "https://github.com/Lartu/ldpl/archive/4.4.tar.gz"
  sha256 "c34fb7d67d45050c7198f83ec9bb0b7790f78df8c6d99506c37141ccd2ac9ff1"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ldpl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a5d1b9c61d666500947c425470ee7108cbd2f2077d68e33b6581b9adc62a87eb"
  end

  on_linux do
    # Disable running mandb as it needs to modify /var/cache/man
    # Copied from AUR: https://aur.archlinux.org/cgit/aur.git/tree/dont-do-mandb.patch?h=ldpl
    # Upstream ref: https://github.com/Lartu/ldpl/commit/66c1513a38fba8048c209c525335ce0e3a32dbe5
    # Remove in the next release.
    patch :DATA
  end

  def install
    cd "src" do
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/"hello.ldpl").write <<~EOS
      PROCEDURE:
      display "Hello World!" crlf
    EOS
    system bin/"ldpl", "hello.ldpl", "-o=hello"
    assert_match "Hello World!", shell_output("./hello")
  end
end

__END__
diff --unified --recursive --text ldpl-4.4.orig/src/makefile ldpl-4.4/src/makefile
--- ldpl-4.4.orig/src/makefile	2019-12-16 13:09:46.441774536 -0300
+++ ldpl-4.4/src/makefile	2019-12-16 13:10:01.648441421 -0300
@@ -51,9 +51,6 @@
 	install -m 775 lpm $(DESTDIR)$(PREFIX)/bin/
 	install -d $(DESTDIR)$(PREFIX)/share/man/man1/
 	install ../man/ldpl.1 $(DESTDIR)$(PREFIX)/share/man/man1/
-ifneq ($(shell uname -s),Darwin)
-	mandb
-endif

 uninstall:
 	rm $(DESTDIR)$(PREFIX)/bin/ldpl
