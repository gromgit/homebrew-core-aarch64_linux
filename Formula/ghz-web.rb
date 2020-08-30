class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.59.0.tar.gz"
  sha256 "132b6d3c6716022f0dfe67e6fbf1cf0311e90b2ab9074b768860a3b9421c8054"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e350d6ef4001b02c0b32f81db4c28bb1b7ca5882ba84178f7c10e71b9e09458" => :catalina
    sha256 "ce25fe1827d18e045520a26d088c3afb64a71c212086463a5ef5171ac727738e" => :mojave
    sha256 "32a6d2be9187fa8539fc98f78021e15f5453d7e67abb5ae2a5ddece28b94fc93" => :high_sierra
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
