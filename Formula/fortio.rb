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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a612e1044edb28f1fb69d8c268da37ef148967ba8a7cc0ef7191e69846007b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "921d3d972e324610fc597ebb1d1ae6f356cf07bc2d13fbee8fcbe8ce70b68eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "ffca3d058930d8da51ea62040505fcb1a217e3caffa8defa9c551477a069963b"
    sha256 cellar: :any_skip_relocation, big_sur:        "751de6c7927ba14da2f7d13def6b29619121512f2c9471de2337ef98760f3f01"
    sha256 cellar: :any_skip_relocation, catalina:       "cc0c9da6f42a162e0e33d092c3158e5b6740edfc70989de59b6ed3964bfc4441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deea1662bee94df39997e7fd45cb7ad12e7c111b2e8b83df776959d5bfb61507"
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
