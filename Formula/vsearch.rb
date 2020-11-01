class Vsearch < Formula
  desc "Versatile open-source tool for microbiome analysis"
  homepage "https://github.com/torognes/vsearch"
  url "https://github.com/torognes/vsearch/archive/v2.15.1.tar.gz"
  sha256 "b10e93f1bdbb79dc689cb6e0c981d71f2e20eb8c4817392aa7f6b30da54e583e"
  license any_of: ["BSD-2-Clause", "GPL-3.0-or-later"]

  bottle do
    cellar :any_skip_relocation
    sha256 "a184d6b0129488bd0bab5c9fac7c69fb8380abede5af74e47545563edced4a1a" => :catalina
    sha256 "1012a84e305c19914cfc54a708434eadf9490890c08c11e0fa0fb16f30edb230" => :mojave
    sha256 "c253a44e9a4eda0e486f96dbaa1fd4494e89572f768e7f09577f180899273fe6" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"vsearch", "--rereplicate", "test.fasta", "--output", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
