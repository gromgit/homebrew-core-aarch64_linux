class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.4.tar.gz"
  sha256 "6a01faca50d4507b21c63e7e2ba4351c5be7765796aafc45b02ff32d3ff5d303"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74cc8962e8a45a9c8ad378d38a60475a3595832be0ce8d2cecee576e49724d46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64fe44caa7a0d4ffd57bdc3bd6d94d2b31d33fead89749c9e9ddf24a7511c9d4"
    sha256 cellar: :any_skip_relocation, monterey:       "28ed05af0c4a69af322bff77427f03dd64571d9867fb13d2fa8fdcead56b11e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "026d2bcb939930e3f9297ac577d853a5a4b53dc08b57ab08728c80b5554d3dc2"
    sha256 cellar: :any_skip_relocation, catalina:       "3c777616a4fb1a6ac7e4aebf4ad959076ee30bd83bc04122a7ea8eec815582b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1f9a58e16b522c35be5f53ae2d40cfc83f460313c1fccd52c7fc76e57d4c3da"
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
