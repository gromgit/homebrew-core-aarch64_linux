class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.34.1",
      revision: "a5d0f122705cc0981419fee4eec51aa18b69a9c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2995bb2d6d7400aaa6072fdb1211950ee19f27ccf139ea48505dc4002f8c27eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eda69d3be01460732e0887398b3997849c521f54b4b0298fddbe0153c0dd9e53"
    sha256 cellar: :any_skip_relocation, monterey:       "f683d1533dda796ffdfbfa32c59d3ab4381a2d99ead37a6005539dc50b222b38"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfe4a6e03de26e1b8d6a9d0467e297ccb8b6a3b2d03039c3c8bf6fc3723f4a92"
    sha256 cellar: :any_skip_relocation, catalina:       "c3df5024993f75a3f80164943820d570e2c85f1651fab09be6540113a917aea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8aa10f3f1ff5fc075df577c338bcd4f492cf50e865a0a6ed02f936e09adcdcf4"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
