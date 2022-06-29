class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.10.28.tar.gz"
  sha256 "3c2c8e1a4cc8cdb4ef626c3d1cd6775588ab3a4fe9c5f25b7ed21fb29176fe5f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf6b8950af3e3d0637bcc91060e67e753bdb63f0cc2b820ee7115dc1dc29c87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f9f9f3bd371017155efe21074b6bd71c7c7865ae590b6937a116d468df7dc14"
    sha256 cellar: :any_skip_relocation, monterey:       "c17bf59e3297cbed2443a5293c5a42ad83b5e3540e9b348efe9673d2e99d2f69"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e3eb7eec1274454236b9702ed75a50c0a5ced898f6b509c3ba97d12e3bbc124"
    sha256 cellar: :any_skip_relocation, catalina:       "3ae7e2b67e239e7de3a5273d9ac2f22ce71593c9f9b20d4300487e4fd7505395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8335c39089eb47faded2bea1215f370b8e8fdba9e966e6703c583b60b2cfdb"
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
    # Fix for error: cannot find derive macro `Deserialize` in this scope. Already fixed on 1.11.x.
    # Can remove if backported to 1.10.x or when 1.11.x has a stable release.
    # Ref: https://github.com/solana-labs/solana/commit/12e24a90a009d7b8ab1ed5bb5bd42e36a4927deb
    inreplace "net-shaper/Cargo.toml", /^serde = ("[\d.]+")$/, "serde = { version = \\1, features = [\"derive\"] }"

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
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
