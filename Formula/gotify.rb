class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "9013f4afdcc717932e71ab217e09daf4c48e153b23454f5e732ad0f74a8c8979"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gotify"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "e40af180356cab41dcb4de2c9ab693daefa1d6a3d00f8d6dcac72b098d1223a4"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}
                                       -X main.BuildDate=#{time.iso8601}
                                       -X main.Commit=N/A")
  end

  test do
    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
