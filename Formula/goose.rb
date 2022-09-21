class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.5.3.tar.gz"
  sha256 "9a5f9dc2b3b5f0876ad1e4609e1d1812e2b9ff03ea04e00c69ca05e7d9584601"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/goose"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ebd9bf301c3ac6765dfd38dd4a5f4c119b2ffdfad4d7fd6b8a7f9ee81bd4e6fe"
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
