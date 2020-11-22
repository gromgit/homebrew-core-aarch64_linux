class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.8.4/pandoc-crossref-0.3.8.4.tar.gz"
  sha256 "4b0b6607271be348b2b9494ea3c3a294915172dedea31b15dce2d56cacb81d25"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "34711c34e4e1a5e74317758a57a02e450b006a86ce2c94202c9d9db89090745a" => :big_sur
    sha256 "9ae3aefae38d75bcca77f2f3991173dfa00150632438e991e839e343c3c33dbd" => :catalina
    sha256 "70842b0d8953f9db8434612136701e3ccbc6079dd76e358d89b85da18931aa3b" => :mojave
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
