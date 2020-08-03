require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.17.0.2/pandoc-citeproc-0.17.0.2.tar.gz"
  sha256 "0b8846ca37547004a6a165ff7f47f58a07f783b01da32c8bf5740272fe37e1f2"
  license "BSD-3-Clause"
  head "https://github.com/jgm/pandoc-citeproc.git"

  bottle do
    sha256 "52cf0b5eebd0a84ecb28e2338fc4df901f792553c7c8ca8e8546365a7f2b2d69" => :catalina
    sha256 "8719e8c8ebc61243c72b68f620328a477fdb5b2a19020d3f08a0073ddaf3494b" => :mojave
    sha256 "4600bd137f299c2e985242dd9c30019ee4ef7c5d93cc0c534352d6ecd7c6cc4c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build

  def install
    install_cabal_package
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    expected = <<~EOS
      ---
      references:
      - id: item1
        type: book
        author:
        - family: Doe
          given: John
        issued:
        - year: 2005
        title: First book
        publisher: Cambridge University Press
        publisher-place: Cambridge
      ...
    EOS
    assert_equal expected, shell_output("#{bin}/pandoc-citeproc -y test.bib")
  end
end
