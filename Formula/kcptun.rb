class Kcptun < Formula
  desc "Stable & Secure Tunnel based on KCP with N:M multiplexing and FEC"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20200930.tar.gz"
  sha256 "90d0851e96ff723d4bcd7fd00795e926418ce5cf17c841e1e0185b0770b84874"
  license "MIT"
  head "https://github.com/xtaci/kcptun.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a24dcf85d60e426dbd0aabb2ff2e71f8a636f08f99e1d7f66304b3888757e113" => :catalina
    sha256 "f3e3b5213b2dfee93d4b4570c7d3b857628500625476e169f7f9d0d6a513eebd" => :mojave
    sha256 "7faf8fbed918092b584bf7b091f66d821f7dbe99bdccff9763aa142376ae66c6" => :high_sierra
  end

  depends_on "go" => :build

  # fix outdated vendored dependencies issue
  # remove in next release
  patch do
    url "https://github.com/chenrui333/kcptun/commit/3a2d679.patch?full_index=1"
    sha256 "ff985884cd20a8e91af61ba1426e5bd21f553c1b42f64a9207e9ae75c38f7217"
  end

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_client", "github.com/xtaci/kcptun/client"
    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", bin/"kcptun_server", "github.com/xtaci/kcptun/server"

    etc.install "examples/local.json" => "kcptun_client.json"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/kcptun/bin/kcptun_client -c #{HOMEBREW_PREFIX}/etc/kcptun_client.json"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/kcptun_client</string>
            <string>-c</string>
            <string>#{etc}/kcptun_client.json</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <dict>
            <key>Crashed</key>
            <true/>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>ProcessType</key>
          <string>Background</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/kcptun.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/kcptun.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    server = fork { exec bin/"kcptun_server", "-t", "1.1.1.1:80" }
    client = fork { exec bin/"kcptun_client", "-r", "127.0.0.1:29900", "-l", ":12948" }
    sleep 1
    begin
      assert_match "cloudflare", shell_output("curl -vI http://127.0.0.1:12948/")
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end
