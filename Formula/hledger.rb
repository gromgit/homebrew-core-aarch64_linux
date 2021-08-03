class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.22.1/hledger-1.22.1.tar.gz"
  sha256 "112cb975488157418bd96c1b820022ca5705a404c02bc75075533bf6a4eb405e"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c154a3c65c8752826f89b3a3c226100c000dbc46df7175c60d470ce62f1b0a20"
    sha256 cellar: :any_skip_relocation, big_sur:       "28545d37d7a0865c9558e54e7696afa35d308c6c31867654da34348ea90b9d2e"
    sha256 cellar: :any_skip_relocation, catalina:      "62edd2f9008af2754bcf6a592d605107311c367907ea958ae1684e51fee655cc"
    sha256 cellar: :any_skip_relocation, mojave:        "8898689adf32582f4c63a0b9ac4ece89286af7e5307fbe02653675a18b343da9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78ed219dc0cf536391bc99e30ce0fd42cf9b96a669e7b6179db8b12f7aac2df3"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.22.1/hledger-lib-1.22.1.tar.gz"
    sha256 "6be4d07e117b15e7534bd3dbbe46c2aac0b21f6c8bd850c10d643815face1f24"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.22.1/hledger-ui-1.22.1.tar.gz"
    sha256 "376e266f9c9b1cc46fbfb75cf94da4b9112310f62bbe952bf37441f0b2ce1b60"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.22.1/hledger-web-1.22.1.tar.gz"
    sha256 "ed325b267f549498f87041b74133c74c4cce298b6d1dbe2a249f4511c0e09309"
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
