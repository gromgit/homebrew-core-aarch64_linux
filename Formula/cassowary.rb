class Cassowary < Formula
  desc "Modern cross-platform HTTP load-testing tool written in Go"
  homepage "https://github.com/rogerwelin/cassowary"
  url "https://github.com/rogerwelin/cassowary/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "385232478b8552d56429fbe2584950bfbe42e3b611919a31075366a143aae9a9"
  license "MIT"
  head "https://github.com/rogerwelin/cassowary.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cassowary"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "09e70586f90bfd524f09243a87a5c45509aea8850ee76b9810125169b76864fa"
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
