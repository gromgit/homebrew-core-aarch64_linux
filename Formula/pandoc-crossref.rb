class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.8.3/pandoc-crossref-0.3.8.3.tar.gz"
  sha256 "5569fb4449e619bc3eafd6e90a6a618622fb6713d3aedc92c1a38b87c218d474"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b7290977c7c81ecfbede54af1c702bd89badca69f6cc64b7ab47503708899d95" => :catalina
    sha256 "736eacab8cc887d6f408de964b382085bb4ae0dd66f3c6258c8ef72cdd99f6cb" => :mojave
    sha256 "64bfd8404e5cc8046ca7a8a5151a019e910acaaf7da2c6595ec95bfc843edd2b" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_match "∑", (testpath/"out.html").read
  end
end
