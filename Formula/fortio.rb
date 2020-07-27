class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.6.3",
      revision: "4313c5b0f2402188a7009ca89b2c8f72f799e866"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "39d31e90bd03a6287b6a9a5a28dc93c61f2555e482932f1ee4b3f38f8ba9f213" => :catalina
    sha256 "0be61266869edab25c8154e6e617eee593e29c7f9b7f05617ff50d513171ba54" => :mojave
    sha256 "d6fa91c01350008dde0a528547a4c4e50be941e0627423924a0075ee9eb058dc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "official-build", "OFFICIAL_BIN=#{bin}/fortio", "LIB_DIR=#{lib}"
    lib.install "ui/static", "ui/templates"
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
      assert_match /^All\sdone/, output.lines.last
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
