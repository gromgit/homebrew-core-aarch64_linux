class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.37.1",
      revision: "0fa89821fab2d9451802ea6195b721d4a94d65a7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1b4cbce83d9f2297f66ddddb67833a2bba602e1d64b9d94eb9f2011b7d43589"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41c75b71fa0ba952553878dcd18dad05890a5bb9685a15c7831a42588ff9bd4f"
    sha256 cellar: :any_skip_relocation, monterey:       "27500fc5436d669567f32eeb3719bd904c6e3e357a53542c4f1da3a57bd35efd"
    sha256 cellar: :any_skip_relocation, big_sur:        "52f8ea31ea3b1b2c2a1723b73dab50b23cc9eb8922b29f5f77e13bf1b797f2a8"
    sha256 cellar: :any_skip_relocation, catalina:       "e1eb9fd3aa8c2a99df6cd8c2c1d04aa470302914d65d9c704e302a625233d9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4858a38210fda25a4b134566e35da3f5a964c54a14de6ddb05633e8282928fd"
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
