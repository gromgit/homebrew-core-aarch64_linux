require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.1.2.tar.gz"
  sha256 "8f43d69a00a8861b156705a634e55179524cefbd98e6c29182e7bdcb57d8b3be"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    revision 1
    sha256 "29f4a14de6d367bcf8aaca3baa39a325566d093974dd3175c5347c79b3ee3407" => :el_capitan
    sha256 "73dc40f0b2263c52d10edff783b94ca60c893a7d6f3cb55daff59a1e4924ac5d" => :yosemite
    sha256 "6a46862b986e2f4daa9981e3d87e9c9a966e024d9c309cd1df41e3a3b8eb8ebd" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # GHC 8 compat
    # Fixes cabal: Could not resolve dependencies
    # Reported 25 May 2016: https://github.com/commercialhaskell/stack/issues/2192
    (buildpath/"cabal.config").write("allow-newer: base,transformers\n")

    install_cabal_package
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
