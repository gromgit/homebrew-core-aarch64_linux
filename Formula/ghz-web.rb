class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.63.0.tar.gz"
  sha256 "2912982c761f8484a3cd23b010a294e8a82515d28b2e33748e7f8b7a36c7979a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4bd57e6d273ce5a79ae570d96a15e363ca9919781c15426cf954b0ffd201a99" => :catalina
    sha256 "7864bd3a2445e0652b6308127def00944a1b37143a7c2cb303ef5415865fec67" => :mojave
    sha256 "06f0573cf87aeae143591a6058d09f411e6d89fd3a604c47ee800d9ac50342ab" => :high_sierra
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match /200 OK/m, shell_output(cmd)
  end
end
