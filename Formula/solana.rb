class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.15.tar.gz"
  sha256 "3fee2d2b65bb57ff58128748b2ced35edfd2c52b7692bf696c5d28ec6c61e0c3"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553bb8031af2c00999d020af9abefe7dbe57b33fae543f03a5b8ba0aa899582c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c051a48e6311f21f5475af32a3d60ea623b43b67e0d7258135b7f666f60b4b3"
    sha256 cellar: :any_skip_relocation, monterey:       "1f65acc4b2b007486a32f7240630fbb0279aa4c6c37f9f232ef73379741ac14c"
    sha256 cellar: :any_skip_relocation, big_sur:        "06d67b7d9b82d18c4118f589e00122db1bb898c62046ce8fe4380851ed0e7b13"
    sha256 cellar: :any_skip_relocation, catalina:       "33a8e7821b16bc9f1424b2bd1fcdd6026c24e738af36b0f287bcdec82b56c98a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499c833740af738d1813be059fd8e4894b3bc36fc52bb6e39fbfd8d04248b6a3"
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
