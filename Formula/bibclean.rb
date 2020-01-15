class Bibclean < Formula
  desc "BibTeX bibliography file pretty printer and syntax checker"
  homepage "https://www.math.utah.edu/~beebe/software/bibclean/bibclean-03.html#HDR.3"
  url "http://ftp.math.utah.edu/pub/bibclean/bibclean-2.17.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bibclean-2.17.tar.gz"
  sha256 "d79b191fda9658fa83cb43f638321ae98b4acec5bef23a029ef2fd695639ff24"

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
      s.gsub! /[$][(]CP.*BIBCLEAN.*bindir.*BIBCLEAN[)]/,
              "mkdir -p $(bindir) && $(CP) $(BIBCLEAN) $(bindir)/$(BIBCLEAN)"
      s.gsub! /[$][(]CP.*bibclean.*mandir.*bibclean.*manext[)]/,
              "mkdir -p $(mandir) && $(CP) bibclean.man $(mandir)/bibclean.$(manext)"

      # Correct `mandir` (man file path) in the Makefile.
      s.gsub! /mandir.*prefix.*man.*man1/, "mandir = $(prefix)/share/man/man1"

      # Place all initialization files in $(prefix)/bibclean/share/ instead of
      # ./bin/ to comply with standard Unix practice.
      s.gsub! /install-ini.*uninstall-ini/,
              "install-ini:  uninstall-ini\n\tmkdir -p #{pkgshare}"
      s.gsub! /[$][(]bindir[)].*bibcleanrc/,
              "#{pkgshare}/.bibcleanrc"
      s.gsub! /[$][(]bindir[)].*bibclean.key/,
              "#{pkgshare}/.bibclean.key"
      s.gsub! /[$][(]bindir[)].*bibclean.isbn/,
              "#{pkgshare}/.bibclean.isbn"
    end

    system "make", "all"
    system "make", "install"

    ENV.prepend_path "PATH", pkgshare
    bin.env_script_all_files(pkgshare, :PATH => ENV["PATH"])
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
