class Prover9 < Formula
  desc "Automated theorem prover for first-order and equational logic"
  homepage "https://www.cs.unm.edu/~mccune/prover9/"
  url "https://www.cs.unm.edu/~mccune/prover9/download/LADR-2009-11A.tar.gz"
  version "2009-11A"
  sha256 "c32bed5807000c0b7161c276e50d9ca0af0cb248df2c1affb2f6fc02471b51d0"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.cs.unm.edu/~mccune/prover9/download/"
    regex(/href=.*?LADR[._-]v?(\d+(?:[.-]\d+[A-Z]?)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/prover9"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a7a6241b43f4ca87f48be68138a722c58075c26a1602db74a68d6e913fb7d7b6"
  end

  on_linux do
    # Order of parameters passed to gcc matters
    # This patch is needed for Ubuntu 16.04 LTS, which uses
    # --as-needed with ld.  It should no longer
    # be needed on Ubuntu 18.04 LTS.
    patch :DATA
  end

  def install
    ENV.deparallelize
    system "make", "all"
    bin.install "bin/prover9", "bin/mace4"
    man1.install Dir["manpages/*.1"]
  end

  test do
    (testpath/"x2.in").write <<~EOS
      formulas(sos).
        e * x = x.
        x' * x = e.
        (x * y) * z = x * (y * z).
        x * x = e.
      end_of_list.
      formulas(goals).
        x * y = y * x.
      end_of_list.
    EOS
    (testpath/"group2.in").write <<~EOS
      assign(iterate_up_to, 12).
      set(verbose).
      formulas(theory).
      all x all y all z ((x * y) * z = x * (y * z)).
      exists e ((all x (e * x = x)) &
                (all x exists y (y * x = e))).
      exists a exists b (a * b != b * a).
      end_of_list.
    EOS

    system bin/"prover9", "-f", testpath/"x2.in"
    system bin/"mace4", "-f", testpath/"group2.in"
  end
end

__END__
diff --git a/provers.src/Makefile b/provers.src/Makefile
index 78c2543..9c91b4e 100644
--- a/provers.src/Makefile
+++ b/provers.src/Makefile
@@ -63,25 +63,25 @@ prover:
	$(MAKE) prover9

 prover9: prover9.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o prover9 prover9.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o prover9 prover9.o $(OBJECTS) ../ladr/libladr.a -lm

 fof-prover9: fof-prover9.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o fof-prover9 fof-prover9.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o fof-prover9 fof-prover9.o $(OBJECTS) ../ladr/libladr.a -lm

 ladr_to_tptp: ladr_to_tptp.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o ladr_to_tptp ladr_to_tptp.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o ladr_to_tptp ladr_to_tptp.o $(OBJECTS) ../ladr/libladr.a -lm

 tptp_to_ladr: tptp_to_ladr.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o tptp_to_ladr tptp_to_ladr.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o tptp_to_ladr tptp_to_ladr.o $(OBJECTS) ../ladr/libladr.a -lm

 autosketches4: autosketches4.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o autosketches4 autosketches4.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o autosketches4 autosketches4.o $(OBJECTS) ../ladr/libladr.a -lm

 newauto: newauto.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o newauto newauto.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o newauto newauto.o $(OBJECTS) ../ladr/libladr.a -lm

 newsax: newsax.o $(OBJECTS)
-	$(CC) $(CFLAGS) -lm -o newsax newsax.o $(OBJECTS) ../ladr/libladr.a
+	$(CC) $(CFLAGS) -o newsax newsax.o $(OBJECTS) ../ladr/libladr.a -lm

 cgrep: cgrep.o $(OBJECTS)
	$(CC) $(CFLAGS) -o cgrep cgrep.o $(OBJECTS) ../ladr/libladr.a
