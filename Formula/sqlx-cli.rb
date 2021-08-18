class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.6.tar.gz"
  sha256 "1e05f706823563f28b14546694281ffd8d076ba6f48126d152add823984e7dbf"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2eb117f2ab7901a954cfdadf03390afa93d9bbde91551b7d0aa7053b62d45e69"
    sha256 cellar: :any_skip_relocation, big_sur:       "6bb3192ed5f6152ee269b5aa5a03f4b89d7c882a8b52dc38688a5c819bcd7a8c"
    sha256 cellar: :any_skip_relocation, catalina:      "ee845da2da501390d08bb5a368a960ad8c635503698cfa6025dd53cec5b65afa"
    sha256 cellar: :any_skip_relocation, mojave:        "3b2622c19d45c07fb81796a159799499b711afb0feef5a63f1a5d7f57da56aa8"
  end

  depends_on "rust" => :build

  def install
    cd "sqlx-cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "error: The DATABASE_URL environment variable", shell_output("#{bin}/sqlx prepare 2>&1", 1)

    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)
  end
end
