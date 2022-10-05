class Openfst < Formula
  desc "Library for weighted finite-state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/FST/WebHome"
  url "https://openfst.org/twiki/pub/FST/FstDownload/openfst-1.8.2.tar.gz"
  sha256 "de987bf3624721c5d5ba321af95751898e4f4bb41c8a36e2d64f0627656d8b42"
  license "Apache-2.0"

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/FST/FstDownload"
    regex(/href=.*?openfst[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/openfst"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3d6c526aca0529fe919509c8b0552ae784040d456cf31878202f8d92489035cc"
  end

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsts",
                          "--enable-compress",
                          "--enable-grm",
                          "--enable-special"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"text.fst").write <<~EOS
      0 1 a x .5
      0 1 b y 1.5
      1 2 c z 2.5
      2 3.5
    EOS

    (testpath/"isyms.txt").write <<~EOS
      <eps> 0
      a 1
      b 2
      c 3
    EOS

    (testpath/"osyms.txt").write <<~EOS
      <eps> 0
      x 1
      y 2
      z 3
    EOS

    system bin/"fstcompile", "--isymbols=isyms.txt", "--osymbols=osyms.txt", "text.fst", "binary.fst"
    assert_predicate testpath/"binary.fst", :exist?
  end
end
