class HopenpgpTools < Formula
  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools-0.23.3/hopenpgp-tools-0.23.3.tar.gz"
  sha256 "576054cc292c8e17dda844820138f05dc20076ad2eea61a165a0ee130b78d0c0"
  license "AGPL-3.0-or-later"
  head "https://salsa.debian.org/clint/hOpenPGP.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8d6b240336e06f4a12a1abc3ba911b398ab565f07c597ad8c5a95a32716b6139" => :catalina
    sha256 "449c9d19526406e7204c302b3b14dfb31637e1ea9b3256518a02ff68422989c5" => :mojave
    sha256 "28978d7cbd8da9251a3bedfadd43b7a79cbea80f8b98e60b81391f45029ff03e" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
