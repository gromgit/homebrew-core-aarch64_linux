class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "1f10e23af218d661e8493e111d425da0ef6f4408d845a473fdbaf45dd6e2d94d"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cassowary"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "f2cc77c44d3cb0884fcc3f3838c0a96f0d2d2ae852786e0857bfb4ed9746103a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cassowary"
  end

  test do
    system("#{bin}/cassowary", "run", "-u", "http://www.example.com", "-c", "10", "-n", "100", "--json-metrics")
    assert_match "\"base_url\":\"http://www.example.com\"", File.read("#{testpath}/out.json")

    assert_match version.to_s, shell_output("#{bin}/cassowary --version")
  end
end
