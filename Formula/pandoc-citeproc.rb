require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.9.1.1/pandoc-citeproc-0.9.1.1.tar.gz"
  sha256 "15c89a9aa6bce4efd6b728ea16151eb6390cad0495eb82c50cbac490591c8f86"

  bottle do
    revision 1
    sha256 "0a73551112932445c426d7daa303423f88342dae660c495b3cdfcc92f9548490" => :el_capitan
    sha256 "6446719a7c2c6221fc64d3fc82a1a0266579b1f94743b8aa8cfe50d3a546dc56" => :yosemite
    sha256 "8b8d1d2ff533cb087b4d4abdb012981e6f41ea86031447b3b37441bc0845691b" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    # GHC 8 compat
    # Fixes "cabal: Could not resolve dependencies"
    # Reported 26 May 2016: https://github.com/jgm/pandoc-citeproc/issues/235
    (buildpath/"cabal.config").write("allow-newer: base,data-default,time\n")

    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
  end

  test do
    bib = testpath/"test.bib"
    bib.write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    system "pandoc-citeproc", "--bib2yaml", bib
  end
end
