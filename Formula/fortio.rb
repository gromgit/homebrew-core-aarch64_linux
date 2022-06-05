class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.32.3",
      revision: "56fa5ab3bb0f93af404e124cf17f3f341450adc4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b87b4765c36cacc14ab117e633f5b2e3cd96135af746590aa997888492f123f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d9aea92f5d6b345a4db0468d0f443dfe8a27e6a4c90ad7a4228c1464146c7be"
    sha256 cellar: :any_skip_relocation, monterey:       "52692ecb1ac79c78fb8d99353b900d07a7382b9008a991848f9069dfc7bb7b36"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae1e7f6ad0f7650206e3768e28abe3fc1d912082fbe59fda90e2a666a2d0660d"
    sha256 cellar: :any_skip_relocation, catalina:       "33231fca8969dbeb6b7e123a8de5b50126c1867969c5f297dff03ec6ac1b2b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8afeea9010901afe52fd8d17a900af2444358ce71fb62e1a53d872725de24afe"
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
