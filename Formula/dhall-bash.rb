require "language/haskell"

class DhallBash < Formula
  include Language::Haskell::Cabal

  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.28/dhall-bash-1.0.28.tar.gz"
  sha256 "f20fc4bdd181f2ead61e5b92b4fc4c155e21d516bc21c0f7196c59ae5327782f"
  revision 1
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "79ece264ad407e62d5e7e678313948c6aebf87babf4f7dcc96418c41e5ca70ae" => :catalina
    sha256 "4e18a58de7dbb04a119e941f2c4cecf3f97ee7999c0b1a779f505cfc6850f955" => :mojave
    sha256 "e784153f410a578bcc00bf1f08532e22f87b1b7bf1617acf8aced84536d2bae6" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
