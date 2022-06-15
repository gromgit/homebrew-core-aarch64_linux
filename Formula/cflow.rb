class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "https://ftp.gnu.org/gnu/cflow/cflow-1.7.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cflow/cflow-1.7.tar.bz2"
  sha256 "d01146caf9001e266133417c2a8258a64b5fc16fcb082a14f6528204d0c97086"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cflow"
    sha256 aarch64_linux: "1b5bcbf6eef16588f9cf91f4556a4f9c66f46714b4d534d7719a220da40a79d2"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"whoami.c").write <<~EOS
      #include <pwd.h>
      #include <sys/types.h>
      #include <stdio.h>
      #include <stdlib.h>

      int
      who_am_i (void)
      {
        struct passwd *pw;
        char *user = NULL;

        pw = getpwuid (geteuid ());
        if (pw)
          user = pw->pw_name;
        else if ((user = getenv ("USER")) == NULL)
          {
            fprintf (stderr, "I don't know!\n");
            return 1;
          }
        printf ("%s\n", user);
        return 0;
      }

      int
      main (int argc, char **argv)
      {
        if (argc > 1)
          {
            fprintf (stderr, "usage: whoami\n");
            return 1;
          }
        return who_am_i ();
      }
    EOS

    assert_match "getpwuid()", shell_output("#{bin}/cflow --main who_am_i #{testpath}/whoami.c")
  end
end
