class ApacheBrooklynCli < Formula
  desc "Apache Brooklyn command-line interface"
  homepage "https://brooklyn.apache.org"
  url "https://github.com/apache/brooklyn-client/archive/rel/apache-brooklyn-1.0.0.tar.gz"
  sha256 "9eb52ac3cd76adf219b66eb8b5a7899c86e25736294bca666a5b4e24d34e911b"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/apache/brooklyn-client.git"
    regex(%r{^(?:rel/)?apache-brooklyn[._-]v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/apache-brooklyn-cli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "af7d570c11dfb214389b5775fbeecfea880eb73847a67f11f8fc7220cf72af67"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/apache/brooklyn-client").install "cli"
    cd "src/github.com/apache/brooklyn-client/cli" do
      system "go", "build", "-o", bin/"br", ".../br"
      prefix.install_metafiles
    end
  end

  test do
    port = free_port
    server = TCPServer.new("localhost", port)
    pid_mock_brooklyn = fork do
      loop do
        socket = server.accept
        response = '{"version":"1.2.3","buildSha1":"dummysha","buildBranch":"1.2.3"}'
        socket.print "HTTP/1.1 200 OK\r\n" \
                     "Content-Type: application/json\r\n" \
                     "Content-Length: #{response.bytesize}\r\n" \
                     "Connection: close\r\n"
        socket.print "\r\n"
        socket.print response
        socket.close
      end
    end

    begin
      mock_brooklyn_url = "http://localhost:#{port}"
      assert_equal "Connected to Brooklyn version 1.2.3 at #{mock_brooklyn_url}\n",
        shell_output("#{bin}/br login #{mock_brooklyn_url} username password")
    ensure
      Process.kill("KILL", pid_mock_brooklyn)
    end
  end
end
