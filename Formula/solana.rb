class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.20.tar.gz"
  sha256 "b7cb1e792167247dc575d49f1a1302e909c68df89d647c313b8c15ede243e99a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e92db1dc03e40bf8b4b578bca377ac65b3d75c3f9e9fed49de1cfe7431bc92ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77abf575f893f21971b7ba6cb9db54c7ba350022438c65a5dffe018ec4c4fafa"
    sha256 cellar: :any_skip_relocation, monterey:       "e3135b3af4c261d9751c8b2f02030a0608b7cc475e933befc757256c0ea45bd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f30718f07461842899ffee81691bd3084fa42c5834b3676e9c6b556364a0181"
    sha256 cellar: :any_skip_relocation, catalina:       "a36266448fca0a383a39e93a5184ee572f4fc4fe4146f866a8cc85e66540e845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ab4ba604bdea51e29219da15f9beff2912dec0f471e4bbc741b941d8679d1c"
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
