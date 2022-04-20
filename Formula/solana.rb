class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.17.tar.gz"
  sha256 "4041bc6439b7b353625e8ccb883afc704b7c9a061867904e0d02c1111265d271"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f730016c27e990f7fef57402ca5c1ab043ccb515486971980256a38235fad73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "663ccb26a5fd723f4f4b34b4fcdcff85b17dfc7c383720ec496765380fa36195"
    sha256 cellar: :any_skip_relocation, monterey:       "575de4d6b902f9f19d2e7b3435beb7283d297e6c42275c60f82e6125c2b8de46"
    sha256 cellar: :any_skip_relocation, big_sur:        "839940f2ece89f2d24f07228f087ee5323a7f473ff9769eb79d9b948930bdfe5"
    sha256 cellar: :any_skip_relocation, catalina:       "7726eab451b51692c9804361513c3cabd74c3815dda631b79a73cd5a2a7b2d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9f5511567f25595b9920a5d52b4c05b1bc1f2e0c88740f417df26830f0a3c1"
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
