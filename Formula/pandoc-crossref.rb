class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.8.0/pandoc-crossref-0.3.8.0.tar.gz"
  sha256 "2d9fed490ea4e9cc617cf545e6035bebf2332843948767ad8d99b8dbda28e2b5"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1a242ce627307e5afc67188fa7eeb5effb16bf38dfd745a2fb6e5b25de190b23" => :catalina
    sha256 "8f31ed90891982ffc6dcdba518a70e8182cfd5dd15f798fe8119c17fd56a5474" => :mojave
    sha256 "c6a52191ef1301876831f24569e1aaa6d9e8149199a677f18767aa770010b413" => :high_sierra
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
