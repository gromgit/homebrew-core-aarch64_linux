class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing."
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.2.0.1/pandoc-crossref-0.2.0.1.tar.gz"
  sha256 "44bdbc38d8d7a743951a2333fb70b33a6497b2d50ccdb5696736fdc5133aef21"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "993ff90a250e2b8f9449d6821f7950512ec89fee88d6924b4099ff34359b69f9" => :el_capitan
    sha256 "20edf6334fec421dddba328dde3ded1f1ea259be46ca469a402e64d293afc9b6" => :yosemite
    sha256 "fa60d9ff3056f423645cab2937f0e9fb8807d6d809ede5ad43d42126125ffcb3" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    md = testpath/"hello.md"
    md.write <<-EOS.undent
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \sum_i a_i x^i $$ {#eq:eqn1}


    EOS
    system "pandoc", "-F", "pandoc-crossref", md
  end
end
