require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "http://haskellstack.org"
  url "https://github.com/commercialhaskell/stack/archive/v1.1.2.tar.gz"
  sha256 "8f43d69a00a8861b156705a634e55179524cefbd98e6c29182e7bdcb57d8b3be"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "74a78e41852fae739720fe03771837ad91fc547fd3f8a1138ff6f4d1ceacffbf" => :el_capitan
    sha256 "435b9a5198e66396b66b9525956296caec01a62c40f236fb6e999d1b2ad83c69" => :yosemite
    sha256 "f3f984dcf53a6a4084d62cf7c7e9d9735c960b39b6bcc106212b5292c1750071" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
