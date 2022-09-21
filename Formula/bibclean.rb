class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "https://ftp.math.utah.edu/pub/bibclean/bibclean-3.06.tar.xz"
  sha256 "6574f9b8042ba8fa05eae5416b3738a35c38d129f48e733e25878ecfbaaade43"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.math.utah.edu/pub/bibclean/"
    regex(/href=.*?bibclean[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bibclean"
    sha256 aarch64_linux: "f8a262e1b035e2e5c27133cef0d66e42f28ce8ad59a0919dcccd04d0a60da907"
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in macOS
      # requires that the full path to the target already exist.
      s.gsub!(/[$][{]CP.*BIBCLEAN.*bindir.*BIBCLEAN[}]/,
              "mkdir -p ${bindir} && ${CP} ${BIBCLEAN} ${bindir}/${BIBCLEAN}")
      s.gsub!(/[$][{]CP.*bibclean.*mandir.*bibclean.*manext[}]/,
              "mkdir -p ${mandir} && ${CP} bibclean.man ${mandir}/bibclean.${manext}")

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub!(/mandir.*prefix.*man.*man1/, "mandir = ${prefix}/share/man/man1")
    end

    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{small,
      author = {Test, T.},
      title = {Test},
      journal = {Test},
      year = 2014,
      note = {test},
      }
    EOS

    system "#{bin}/bibclean", "test.bib"
  end
end
