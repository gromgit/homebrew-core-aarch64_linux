class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.25.tar.gz"
  sha256 "ebed35ae8ccdb8abfe12b865e175fafc15ab05715fb14081be3fa7fe764e6b9a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7f6179c458520b720dd6fd461e75b0d055ace7440219b77ff0e2acdd1e7b3f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9661639a87ab70426b666df30424068d93d123a7a0ea5f0dda5fb5d5e67f52fc"
    sha256 cellar: :any_skip_relocation, monterey:       "a59209517d1f3bfe7f3a7661f1a3c9f97fd00cbaf0b429625ba04c1e9cf2064c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad3ad3fd59944d016c2860898fdfd425ae16c1c552c44abd3f1d11ac9a92bc8d"
    sha256 cellar: :any_skip_relocation, catalina:       "796dce1296b08dd5d3ee6c1b818a01a372e4ebf0669df0eb83272a6c9881d96f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089c7073a5e9faeff8cfc3ed10906c277cd1bf13040785e678b9c795225db014"
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
