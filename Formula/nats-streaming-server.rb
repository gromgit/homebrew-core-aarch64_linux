class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.24.6.tar.gz"
  sha256 "750e091f3473688a1b0c251513bf9beb7a12e3e1359d541b53381bd91e09b9be"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nats-streaming-server"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "498ffe00078666d9ff9403a6ae65a2417514ebd5283c1d07cc572b4176f4d2bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-streaming-server"
    prefix.install_metafiles
  end

  service do
    run opt_bin/"nats-streaming-server"
  end

  test do
    port = free_port
    http_port = free_port
    pid = fork do
      exec "#{bin}/nats-streaming-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "uptime", shell_output("curl localhost:#{http_port}/varz")
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
