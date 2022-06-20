class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.41.tar.gz"
  sha256 "13e532c7b364f7d57e23dfeea3147103150cb90593a57af86c10e4f6e411603f"
  # libmagic has a BSD-2-Clause-like license
  license :cannot_represent

  livecheck do
    formula "file-formula"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libmagic"
    sha256 aarch64_linux: "59c69dd0e8abc98ae865da12e76d02e82be430190e413a1791c0cab69163165d"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share/"misc/magic").install Dir["magic/Magdir/*"]

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>

      #include <magic.h>

      int main(int argc, char **argv) {
          magic_t cookie = magic_open(MAGIC_MIME_TYPE);
          assert(cookie != NULL);
          assert(magic_load(cookie, NULL) == 0);
          // Prints the MIME type of the file referenced by the first argument.
          puts(magic_file(cookie, argv[1]));
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmagic", "-o", "test"
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
