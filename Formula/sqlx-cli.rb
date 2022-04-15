class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.12.tar.gz"
  sha256 "20868a25f3807e5a59f0f7938a1f10ad57432764c13eb3c61002305c2e281aee"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92285cb3d8d0890436e871e5594ffb25f87af7ad85a77e3dde2121733e29ba5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f674a1adf750d71904abc40c48536f768b022bfb76eae9369a4703162d85f58c"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc7840e7a367e4f6a1af70306ad968361ef09dc5f46ab20a76b3ccb62313410"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a999b00841dbd38a446a7dfbb28dd3f8bb2f86d7e3bbf846ab04ed83baabbee"
    sha256 cellar: :any_skip_relocation, catalina:       "9f3b47148a33b11c8035a25ac2e540543c8a6d7475a8a007a7f3abf138d39132"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
