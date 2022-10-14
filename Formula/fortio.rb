class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.38.1",
      revision: "fbcebcb68e5799b357fd2f48289b2c69781d5001"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de2f7cdff58dd2a5fbed2afa12b31676e3d71013a98dd09c456f0281eeedbeed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e7db2bb578940e0834d4393b7c962b69c09319c8151eaa62d9715be7c4ca241"
    sha256 cellar: :any_skip_relocation, monterey:       "04de02e3dbeb4628ffab6b4c524328451a129483f33ff3f95b17f2ccb591b018"
    sha256 cellar: :any_skip_relocation, big_sur:        "1153077c3c8ff525431c129ae690f527a1dc5ce46e958b6f461411e294c3f916"
    sha256 cellar: :any_skip_relocation, catalina:       "e0921f752e209a536f2c0649fcd5063918517b3e3177885c8c0fa22682028e37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c3ba681c992720b0268d6588f8fb6dfd620705d9a869ad9bc01f31069e1758b"
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
