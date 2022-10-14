class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.13.3.tar.gz"
  sha256 "75a10aee455f6833e2cc5fd68756a934fe73bda1683947c42ac6b61c30f88a82"
  license "Apache-2.0"

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>[^<]*?Mainnet}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa7489268a92c4dbe97c15be39e85f6f8f4e075b813a4255ba1d22fd5dc8a125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45f391755dc12061b295ab56bf6cef9835b146a558c3114fa9bc29c9bc63572f"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3f778283fb2141cc829410231a0631ece8c7795f20aba1813a3f0daa4aecee"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6d8b03ca08d9cac9c1233212be377ba964504cad0897467a930aa5d9544badb"
    sha256 cellar: :any_skip_relocation, catalina:       "eee428f7cdc607e90500e1b6430b23b7f86684538fa12e97646f971386b96c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4da687047e49635235bc0de474c3bee5ffaf34c05afa87322237625f61011fd3"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
    depends_on "systemd"
  end

  def install
    # Fix for error: cannot find derive macro `Deserialize` in this scope. Already fixed on 1.11.x.
    # Can remove if backported to 1.10.x or when 1.11.x has a stable release.
    # Ref: https://github.com/solana-labs/solana/commit/12e24a90a009d7b8ab1ed5bb5bd42e36a4927deb
    inreplace "net-shaper/Cargo.toml", /^serde = ("[\d.]+")$/, "serde = { version = \\1, features = [\"derive\"] }"

    %w[
      cli
      bench-streamer
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      sys-tuner
      tokens
      watchtower
    ].each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
