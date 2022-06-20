class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/bcicen/slackcat/archive/refs/tags/1.7.3.tar.gz"
  sha256 "2e3ed7ad5ab3075a8e80a6a0b08a8c52bb8e6e39f6ab03597f456278bfa7768b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/slackcat"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4ea5dd0db05c90f8da16fdb866cc04cd725ded980eda02359221a0b1dcaa3831"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slackcat -v")
  end
end
