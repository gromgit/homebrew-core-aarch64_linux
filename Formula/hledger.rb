class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://hackage.haskell.org/package/hledger-1.22/hledger-1.22.tar.gz"
  sha256 "0c5f53bfb6c6e0fb8ac7c85a1592b3fd76318f1b989765ddd0e7d89b689beaf0"
  license "GPL-3.0-or-later"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c7c03fa909e3d54ff4efe598a40d1bcc3da9c10a307406658c26fa20fff1e402"
    sha256 cellar: :any_skip_relocation, big_sur:       "83d91bd5847275c6e7089b71332015c71272bc24f562a55b595e8c192bfe7285"
    sha256 cellar: :any_skip_relocation, catalina:      "5f812bbfa7a4409166716730edf3fda92bb6a6dcb99572440d926a56e47554b2"
    sha256 cellar: :any_skip_relocation, mojave:        "0a379919ad9936b1b93b7af1103fd5c98656c43ed879eea8f2e0dcfdcccb2e0a"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "hledger-lib" do
    url "https://hackage.haskell.org/package/hledger-lib-1.22/hledger-lib-1.22.tar.gz"
    sha256 "f54f257fd5fa7449d787da94311673097307c9ef0c0e1b0578034b68c56c0d1b"
  end

  resource "hledger-ui" do
    url "https://hackage.haskell.org/package/hledger-ui-1.22/hledger-ui-1.22.tar.gz"
    sha256 "593e03188e98340dcb2146bf8478f39ae2c4927bfe9e3f18c0f03dcffb6df1c7"
  end

  resource "hledger-web" do
    url "https://hackage.haskell.org/package/hledger-web-1.22/hledger-web-1.22.tar.gz"
    sha256 "7a11cbc94790d5e25156d7fe1c973bcc7e7aa30ac9ea8322e0d8a3ff43083e56"
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
