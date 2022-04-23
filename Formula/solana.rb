class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.18.tar.gz"
  sha256 "9b20130662d93c5db7f8e0e443a35abb470378de767f3d682e3538d3155ee1e9"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6185bd7ce22ffb6e1e8bc76c9ec14221da4f52fdecf61a10e7de6a9e36a60ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a819d6940fc1bcc9862c147ebbb950160e9497c0883f9818e6b7f9c7abcbc1e"
    sha256 cellar: :any_skip_relocation, monterey:       "ac12905530cff2f50be747c71a7c266a0b215ef321ad69143b937281ff8d39ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "761ae9ab37d18255a1c99994b9568e5188e1240f40483da44fe902842adb77ae"
    sha256 cellar: :any_skip_relocation, catalina:       "eda53ce1621169d19701deb2d2674cb6e46e034fbe834edb9d369c8ba7df4ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9dd634ec783aaf1f5b0c894cedb210c9ceea723a9a7c7cc97fc5fe474244eaf"
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
