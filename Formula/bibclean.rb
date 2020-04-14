class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "http://ftp.math.utah.edu/pub/bibclean/bibclean-3.04.tar.xz"
  mirror "https://dl.bintray.com/homebrew/mirror/bibclean-3.04.tar.xz"
  sha256 "4fa68bfd97611b0bb27b44a82df0984b300267583a313669c1217983b859b258"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "635f879a68a634caf12bff8930a27c0427b37bfb8332b7febfce34e62bb892e7" => :catalina
    sha256 "f095e3e8a61f36dac9bff1687c7c11fddbe75c67f4dded0f82a6a95399d9a8c6" => :mojave
    sha256 "485c4641efc1716e3de1e7672f5b3a444a0ce7fb3eb516d16fa93292907f931d" => :high_sierra
  end

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # The following inline patches have been reported upstream.
    inreplace "Makefile" do |s|
      # Insert `mkdir` statements before `scp` statements because `scp` in macOS
      # requires that the full path to the target already exist.
      s.gsub! /[$][{]CP.*BIBCLEAN.*bindir.*BIBCLEAN[}]/,
              "mkdir -p ${bindir} && ${CP} ${BIBCLEAN} ${bindir}/${BIBCLEAN}"
      s.gsub! /[$][{]CP.*bibclean.*mandir.*bibclean.*manext[}]/,
              "mkdir -p ${mandir} && ${CP} bibclean.man ${mandir}/bibclean.${manext}"

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub! /mandir.*prefix.*man.*man1/, "mandir = ${prefix}/share/man/man1"
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
