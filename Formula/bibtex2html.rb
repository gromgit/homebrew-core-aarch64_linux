class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.99.tar.gz"
  sha256 "d224dadd97f50199a358794e659596a3b3c38c7dc23e86885d7b664789ceff1d"

  livecheck do
    url :homepage
    regex(/The current version is v?(\d+(?:\.\d+)+) and/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bibtex2html"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b5c4930094f31ce4f3e5c9c370570d4354d6cb58b407bd089840244f08c0965a"
  end

  head do
    url "https://github.com/backtracking/bibtex2html.git"
    depends_on "autoconf" => :build
  end

  depends_on "ocaml" => :build

  def install
    # See: https://trac.macports.org/ticket/26724
    inreplace "Makefile.in" do |s|
      s.remove_make_var! "STRLIB"
    end

    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS
    system "#{bin}/bib2bib", "test.bib", "--remove", "pages", "-ob", "out.bib"
    assert(/pages\s*=\s*\{3--4\}/ !~ File.read("out.bib"))
    assert_match(/pages\s*=\s*\{3--4\}/, File.read("test.bib"))
  end
end
