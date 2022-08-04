class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.10.34.tar.gz"
  sha256 "0c35585c0e82a86186243b56239dcc0fa1a7ffd0ba64436bcf87db6820a52dc6"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a40d288361c2aae97a71aecd591588e1d4d8d49e3563e5976ad5c854628208c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e1430fd836ac6f82f2b463ae7a33a8cfd2a5db5cdbe9cbce0c933c936aa47b0"
    sha256 cellar: :any_skip_relocation, monterey:       "3b5c2ade7a541401a15b9201740713ce3149b88c3d17d7b9865b7c6f75232a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "e54969f1acf90cfbe93f64265bf311d4ce85278c8587a12f2e5c79bcbf450500"
    sha256 cellar: :any_skip_relocation, catalina:       "124d0f29c39c789dae3680f585ee883aba068d37e037b89b865c2d38802e4691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8183c8ec2e351cf6e489111dcbfc4920fe647cbbd751ada225e173d0740a4aa"
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
