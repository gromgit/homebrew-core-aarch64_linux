class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/v0.5.13.tar.gz"
  sha256 "3ef2dabb47403ddbbdd5d6c48f73e00f7e9db45d2581e6991231e0492633a811"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2758f78ff1e0c1c709b64838e00d928adf7f26d1f52e69528baf8dc1b178cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f698c1f1cba462044fec3f64e1f4332efb8fdf71c995970d694b74faedc7bfc5"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f3ceb95df8cf11b109ca731fc3b6a8734ab9be581510561924deb29dfce45d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b34f1fd15c8efe55431ffcc18eaf5ea426c62729ed69d4dea9fc970b80fd3fe6"
    sha256 cellar: :any_skip_relocation, catalina:       "a7622dc0963fbdf5de2faf5dfa5b4a3fe7ccaabb3e24e95c5adae8c549028b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c779d4731021df755c4d494727ad37fef1ddcdcb07b74b1fdb7851ceb2f3c175"
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
