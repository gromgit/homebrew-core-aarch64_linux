class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.26/hledger-1.26.tar.gz"
  sha256 "e2dd5b92d9484de385498c5463db8651fb44474e52a7d85096c1faa4ab2df495"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f41427d749dcd466909f2c2e4a662c4c89da200648dc7732b17e65b8795bb12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05173d9e8034d2cb83d25f125ec98933e1db8c671efb0def3f62069627c1d6fc"
    sha256 cellar: :any_skip_relocation, monterey:       "3c8558a9d45321d46f2253ddc593b56465aeb345a1268f294d316ba55d683389"
    sha256 cellar: :any_skip_relocation, big_sur:        "519d90342e465edb936d0a9d58c3b651af4e61b3a84b46168670c7d24caa1ca9"
    sha256 cellar: :any_skip_relocation, catalina:       "6b0daa38719dc5e5ec287426e812e915ac5ee0f50ede5943767d701e85217b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae297f309959b1f40ce06a6940933f9e2cd7f3a1314b4c37bcade6e402524943"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.26/hledger-lib-1.26.tar.gz"
    sha256 "fe0e33fcd7be2f24aeebd11145e1c7afe212572b24a4b5299ca991d0f00b3a95"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.26/hledger-ui-1.26.tar.gz"
    sha256 "2891a6ace8279a3da4a07b76bbd9eb95261633f011f9a5d016d718c1b62fa427"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.26/hledger-web-1.26.tar.gz"
    sha256 "6aa2c4096aa73c8b55fa870845138aec76e08ebadc41dfc8faaf10b3274a90c0"
  end

  def install
    (buildpath/"../hledger-lib").install resource("hledger-lib")
    (buildpath/"../hledger-ui").install resource("hledger-ui")
    (buildpath/"../hledger-web").install resource("hledger-web")
    cd ".." do
      system "stack", "update"
      (buildpath/"../stack.yaml").write <<~EOS
        resolver: lts-17.5
        compiler: ghc-#{Formula["ghc"].version}
        compiler-check: newer-minor
        packages:
        - hledger-#{version}
        - hledger-lib
        - hledger-ui
        - hledger-web
      EOS
      system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"

      man1.install Dir["hledger-*/*.1"]
      man5.install Dir["hledger-lib/*.5"]
      info.install Dir["hledger-*/*.info"]
    end
  end

  test do
    system "#{bin}/hledger", "test"
    system "#{bin}/hledger-ui", "--version"
    system "#{bin}/hledger-web", "--test"
  end
end
