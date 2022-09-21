class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.5.1.tar.gz"
  sha256 "841f5524e2e107bff278b604c544843564a4a1ef0c3803eeae588e79e4ea5d06"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/caddy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "64b3d2dfd33ff9396b0401df694ea3bd819d18b27799717459c99142afdace5f"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.3.0.tar.gz"
    sha256 "1a59ff6f51959072a512002e7ec280ea96775361277ba046a8af5a820a37aacd"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end
  end

  service do
    run [opt_bin/"caddy", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/caddy.log"
    log_path var/"log/caddy.log"
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
