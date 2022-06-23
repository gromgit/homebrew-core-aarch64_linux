class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://github.com/pressly/goose"
  url "https://github.com/pressly/goose/archive/v3.6.1.tar.gz"
  sha256 "e1caf2b7130e4d6c7190582707304c417f47c84efc2e6f79968811b30c86bc6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a930ece415c707e05ec649785d5e8d9a4bee44662293bbfedd4c9a0e9e405d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e519641035bd23c50470f265d39a99d754664d9dd969e3bd5e4b2777353e19c"
    sha256 cellar: :any_skip_relocation, monterey:       "121350b7a466482dc0e4ebd296bab6a5614e648d6b557393437671b49ade4696"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a38c26a43fa19bb6b56b9c38a57ac9b7254c6d4f0a3cc0e018cd95534dcaf22"
    sha256 cellar: :any_skip_relocation, catalina:       "78297d0a219e945ac4d7c8165fa4e4be638c84a7929e6370fab83272b958846c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63458f963b42bb7bb5b019f70ce3cbb3937a42b886c7bb7e3451fec34ed6ba98"
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
