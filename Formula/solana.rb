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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c03192d2167f3e058796bdc8179a69c1ff8f99d72d1f4500547cdbcafdb4aff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3932b2f329032b393b3809bab55be7450458b91eddfad1920551979672e9ad46"
    sha256 cellar: :any_skip_relocation, monterey:       "9abd162263bfbda475cd9a379b19ac81c918dc0cafc12769dff2765eb12c6bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae2a0c1fdcc3d833625dbf7ff6454d2189ce33cbf474416eaaa7a9e986b5c5c"
    sha256 cellar: :any_skip_relocation, catalina:       "07717ff3148ec21a7cdf77fd19fa29d2f1e83138109a9a4aeae4724d1739b3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3e321000ae16eda2095885227d35ff05dd97476312c41160c491ed98b99879"
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
