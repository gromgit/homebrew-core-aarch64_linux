class Diesel < Formula
  desc "Command-line tool for Rust ORM Diesel"
  homepage "https://diesel.rs"
  url "https://github.com/diesel-rs/diesel/archive/v2.0.1.tar.gz"
  sha256 "b425d5f5c95e7c70fbd43b9e15a7f4a97cfd41625cc236072d86c4bd104c9a4a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/diesel-rs/diesel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d63c5307c44cd24738f2b7b9f58b28811810226f1e325147a1ec8536439319c"
    sha256 cellar: :any,                 arm64_big_sur:  "c84d578a3b0373d01acd4d6c8c93e9ed191c71a1bae18af8b76e02b57aeed33c"
    sha256 cellar: :any,                 monterey:       "bbe362db85f543b2073c57f50ed0666900951cbd6cb24cba22f9d57edebe0148"
    sha256 cellar: :any,                 big_sur:        "b6c17494a3c5797bb360effc82317665f1fbe9a52e63ceb2ab90a1ef942012bc"
    sha256 cellar: :any,                 catalina:       "a2ba78de067ca4fdba6b4d5229db289ea3260f4744376e16fd6aa4678948b29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0639a2f754cf9a48f660cb84c53fe2a500312778bfc0e511ca1ee9c64504a4c0"
  end

  depends_on "rust" => [:build, :test]
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "sqlite"

  def install
    # Fix compile on newer Rust.
    # Remove with 1.5.x.
    ENV["RUSTFLAGS"] = "--cap-lints allow"

    cd "diesel_cli" do
      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"diesel", "completions")
  end

  test do
    ENV["DATABASE_URL"] = "db.sqlite"
    system "cargo", "init"
    system bin/"diesel", "setup"
    assert_predicate testpath/"db.sqlite", :exist?, "SQLite database should be created"
  end
end
