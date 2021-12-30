class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.10.tar.gz"
  sha256 "e2fd9d89cdaf1cf9f91d83a7b29d533ef72da1e8b6e138b4b36df8c8a38efe78"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de11c9374ee25b672dfa22b8a57bdffc0862f74e3b63e36a726f1b91bccaafd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c2d72a10269103d8da8a0f6927604e7e3a8903c0a58d82ab015ac81dde36e47"
    sha256 cellar: :any_skip_relocation, monterey:       "2810bedc07f56ee3a1906deb97fe04ccf1ea6fc46178e9ef888465740ba1bf9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "17a2d1181fbadd1306ea55bf7c37157038520120bb0613647c1989d0f1bfcd1e"
    sha256 cellar: :any_skip_relocation, catalina:       "e3d7e6a20cb4b860810ce07352ffbebb35ddc81c24c676beb88c1353c06226bd"
  end

  depends_on "rust" => :build

  def install
    cd "sqlx-cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "error: The following required arguments were not provided",
      shell_output("#{bin}/sqlx prepare 2>&1", 2)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
