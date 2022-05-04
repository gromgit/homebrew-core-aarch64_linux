class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.19.tar.gz"
  sha256 "7f816fcaa7647d1e94d318e3f0ce7a98efab2f418561ffb19dc04c5fbe132231"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "074bef514a6dba871521f3b370ee338db69afa52bea23680baa89bd3388a1394"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ade8bf5f7b4c6b0461439d2392e0b3c9f443ac83563e015a94dd55bb33b4a11e"
    sha256 cellar: :any_skip_relocation, monterey:       "77016eada78b55b65f21ef09e63cb1df6cb99531718eb83792060532e8e10911"
    sha256 cellar: :any_skip_relocation, big_sur:        "c18a7010c181253522a0add1af5967b1e395a0863fbabaca20e1335bcbea4fd5"
    sha256 cellar: :any_skip_relocation, catalina:       "6cca3df7ad95250d8be891bd580fb92e06bf8adbd6fd1e557aab22fd4dcb2a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ce9e9799a1e5bbd502b7994209310b6fc5161386f4c91e42f69b801cc85093"
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
      cd bin do
        system "cargo", "install", "--no-default-features", *std_cargo_args
      end
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
