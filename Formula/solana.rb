class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.24.tar.gz"
  sha256 "0a58c811a582f0d018f56a6014f92ffb3140e754c37e32434defa37f4cf1780d"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c9da6477d343325b20adeff77d445a684562f27c4981414615686e8f3fef3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcc2156d1c05644c4d60ee2cc7466fbe5876d8ce585b0bf5488ab976c9ffb724"
    sha256 cellar: :any_skip_relocation, monterey:       "7c92485104d0cbf33a52b65007436ff9487f5543ac78292cda705abe7734098c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f215a43fb7021f4dfb0810ef9ddf86cb48a7497f65d1207011487586857bdd0"
    sha256 cellar: :any_skip_relocation, catalina:       "9cd78ecf3f0538050955119e3715a85d367ff7feddbae7a4a047d4d279c49479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a13546b096e4f9af3ed1c896007f1cc493159e991852dabeaef6769b6b6def"
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
