class GnuProlog < Formula
  desc "Prolog compiler with constraint solving"
  homepage "http://www.gprolog.org/"
  url "http://www.gprolog.org/gprolog-1.5.0.tar.gz"
  sha256 "670642b43c0faa27ebd68961efb17ebe707688f91b6809566ddd606139512c01"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?gprolog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gnu-prolog"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cababb076550b16fbddc1da7b4b127b92a5bee72a9b833cc29be698afb5ee69c"
  end

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}", "--with-doc-dir=#{doc}"
      ENV.deparallelize
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.pl").write <<~EOS
      :- initialization(main).
      main :- write('Hello World!'), nl, halt.
    EOS
    system "#{bin}/gplc", "test.pl"
    assert_match "Hello World!", shell_output("./test")
  end
end
