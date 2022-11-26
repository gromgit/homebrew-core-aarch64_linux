class Clash < Formula
  desc "Rule-based tunnel in Go"
  homepage "https://github.com/Dreamacro/clash"
  url "https://github.com/Dreamacro/clash/archive/v1.12.0.tar.gz"
  sha256 "9b8f28c2adf378e4da5b139dd72c3e13bf19394e2555080832dc47c64fbcdb9a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ab81d21a9be4917b0a93b8465e95e2d18decbaf10015e5a51d82db80ba0ab11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f42c47477ef9236d7a24d9d767454b03d637f00e0052df6ae5d3cf643ecb730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a28ae7aaa679e501439fc812b92f3d79a5632d78ec6cc6e4053108a80ee78d9b"
    sha256 cellar: :any_skip_relocation, ventura:        "bee8d6ae1a62159bbd5a4bd1df8d8b853a189f79d5c52654ed52d0759d9bfcc0"
    sha256 cellar: :any_skip_relocation, monterey:       "4cc4b392ed78a1e4a4a759aa95b33896c34a1dc7d30f433c02b554a2131f18f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0469cbe98994fa34812069fd0e57b7f8bca0f17c57bc3994ed6a47a46f4e9c5"
    sha256 cellar: :any_skip_relocation, catalina:       "a234c3326bc032d1692ec8f92c43fbd104f284795d0f245f09baf5a7fa9e3a50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01f24428b84837fb381612ac14da410daa4dcb4c860065d1e26a1d696e9b1a9c"
  end

  depends_on "go" => :build
  depends_on "shadowsocks-libev" => :test

  def install
    system "go", "build", *std_go_args
  end

  service do
    run opt_bin/"clash"
    keep_alive true
    error_log_path var/"log/clash.log"
    log_path var/"log/clash.log"
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks-libev.json").write <<~EOS
      {
          "server":"127.0.0.1",
          "server_port":#{ss_port},
          "password":"test",
          "timeout":600,
          "method":"chacha20-ietf-poly1305"
      }
    EOS
    server = fork { exec "ss-server", "-c", testpath/"shadowsocks-libev.json" }

    clash_port = free_port
    (testpath/"config.yaml").write <<~EOS
      mixed-port: #{clash_port}
      mode: global
      proxies:
        - name: "server"
          type: ss
          server: 127.0.0.1
          port: #{ss_port}
          password: "test"
          cipher: chacha20-ietf-poly1305
    EOS
    system "#{bin}/clash", "-t", "-d", testpath # test config && download Country.mmdb
    client = fork { exec "#{bin}/clash", "-d", testpath }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{clash_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
