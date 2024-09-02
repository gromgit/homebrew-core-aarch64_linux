class Websocketd < Formula
  desc "WebSockets the Unix way"
  homepage "http://websocketd.com"
  url "https://github.com/joewalnes/websocketd/archive/v0.4.1.tar.gz"
  sha256 "6b8fe0fad586d794e002340ee597059b2cfc734ba7579933263aef4743138fe5"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/websocketd"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5f5ef050bb92f97f945010ffa1c4783a3c5a0eb918edf531a935d605cd105aef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=#{version}", *std_go_args
    man1.install "release/websocketd.man" => "websocketd.1"
  end

  test do
    port = free_port
    pid = Process.fork { exec "#{bin}/websocketd", "--port=#{port}", "echo", "ok" }
    sleep 2

    begin
      assert_equal("404 page not found\n", shell_output("curl -s http://localhost:#{port}"))
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
