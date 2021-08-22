class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.8/dhall-yaml-1.2.8.tar.gz"
  sha256 "5359f4d4e0f8aa96ef5d6788e33654a508b6c38130d4034b146eacc89737e6dc"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6faeee1096a47ee1b85c90c9810c6a202493cbc68a3951c68958c13616344230"
    sha256 cellar: :any_skip_relocation, big_sur:       "8345b848010e3920b06d53cbd271b572bf7d1f6d74219b6e81fb4f8a438de578"
    sha256 cellar: :any_skip_relocation, catalina:      "e4022dec09fd40dde84c6699be5b82d058937ec290383e405c2da70f53df208d"
    sha256 cellar: :any_skip_relocation, mojave:        "8404c619dac4c59dec00546088de2b0e8580368210b8a31fdfd0781ba58d0fd4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
