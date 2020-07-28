class Traefik < Formula
  desc "Modern reverse proxy"
  homepage "https://traefik.io/"
  url "https://github.com/containous/traefik/releases/download/v2.2.8/traefik-v2.2.8.src.tar.gz"
  version "2.2.8"
  sha256 "d457da29b178db3d9245fdd94753f9fc4e33a503691a0ee4e32daf8103cac71d"
  license "MIT"
  head "https://github.com/containous/traefik.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "64b4dba7b4247d81109077c39f1b12786dbd2fd74cf35b08b0b79039e3c47d35" => :catalina
    sha256 "cc0b34ab691f1f8be132ee385f1fe5522a667615a0ab8e79ddf47ee93719c03a" => :mojave
    sha256 "1cdc92f9a3aab076d012d3b03473525a8f1205197950aba58e0f5ac05ec60e4a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go", "generate"
    system "go", "build",
      "-ldflags", "-s -w -X github.com/containous/traefik/v2/pkg/version.Version=#{version}",
      "-trimpath", "-o", bin/"traefik", "./cmd/traefik"
    prefix.install_metafiles
  end

  plist_options manual: "traefik"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/traefik</string>
            <string>--configfile=#{etc/"traefik/traefik.toml"}</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/traefik.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/traefik.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    ui_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [entryPoints]
        [entryPoints.http]
          address = ":#{http_port}"
        [entryPoints.traefik]
          address = ":#{ui_port}"
      [api]
        insecure = true
        dashboard = true
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match /404 Not Found/m, shell_output(cmd_ui)
      sleep 1
      cmd_ui = "curl -sIm3 -XGET http://127.0.0.1:#{ui_port}/dashboard/"
      assert_match /200 OK/m, shell_output(cmd_ui)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end

    assert_match version.to_s, shell_output("#{bin}/traefik version 2>&1")
  end
end
