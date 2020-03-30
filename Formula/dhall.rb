require "language/haskell"

class Dhall < Formula
  include Language::Haskell::Cabal

  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.31.0/dhall-1.31.0.tar.gz"
  sha256 "3c98d11602a4be453624a9f9281017324a418c7606e819a025bfa53227fcb732"

  bottle do
    cellar :any_skip_relocation
    sha256 "be6dadc022fd232e86a0916fd87616927bfbc710bb412063dfe2ba6d4ad29005" => :catalina
    sha256 "5aae405c74317ab25576d76b298bfdd23041207248708520f81efcac61f381b2" => :mojave
    sha256 "d09056f7797e39f692819c8039d679e01e9c2c52c253a3e3bf4fa3dea5734aa9" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "∀(x : Natural) → Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
