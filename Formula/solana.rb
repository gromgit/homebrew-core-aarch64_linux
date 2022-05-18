class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.22.tar.gz"
  sha256 "63a7d1918084bba48eeb9387b185ab551fc2c3c42b8c7eca3b0f389655b44ddb"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d270b699cda2ee58dc96c9adb8c8171437bf7024d73d3d2b8e1636e6b10d3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0609c36eeaea11258020761053c74bc91c3088eb5024e9e12900d09330a838d1"
    sha256 cellar: :any_skip_relocation, monterey:       "8055efe0cf7705a5e0dde5418e145a0336efe77c3acf87d68f0980194fcb41e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "962f9e0d776c57f72a98fda49a155a1bf23b634e3c083ebc151c132c47713646"
    sha256 cellar: :any_skip_relocation, catalina:       "6c2821933e8e809187b3175e6322699a53a3fd5e9b06a5876fa2dedd29909ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ca3b165b8889c046608ca9e239070222be01ef39eb9c0751cd4d4c9e72049e6"
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
