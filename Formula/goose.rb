class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.7.0.tar.gz"
  sha256 "704feecc502f08b69e53135df3125b88f6b94174c51448c8c5013dba7389efa3"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/goose"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7fcb92e1d68d91cecc343249d1aa2871f49492f2d1d478a495ea9e161923c04f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1")
    assert_match "Migration", output
    assert_predicate testpath/"foo.db", :exist?, "Failed to create foo.db!"
  end
end
