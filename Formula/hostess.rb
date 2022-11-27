class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/v0.5.2.tar.gz"
  sha256 "ece52d72e9e886e5cc877379b94c7d8fe6ba5e22ab823ef41b66015e5326da87"
  license "MIT"
  head "https://github.com/cbednarski/hostess.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/hostess"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "040c056d8d556f4fa9ef9f39c3ca6fa44f92d4331236b633077939cf37c512da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "localhost", shell_output("#{bin}/hostess ls 2>&1")
  end
end
