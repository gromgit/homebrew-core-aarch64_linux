class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.95",
      revision: "19c8673a044deb3ec419e05b74b3fd745fe8678c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "619f94589ac0509a812c35b9537a61014cef95e6c390b43e6ee714590950b1d3" => :big_sur
    sha256 "d40cad6d997c01d5ac077be80822f6f49e9c69681506ab3bde703697d2d205a2" => :arm64_big_sur
    sha256 "29d348627eaf641ad24036a54c835dbdb8864f84a803113faed10330e22607b0" => :catalina
    sha256 "c5c13841c70ed28694b18659125bec1dda2249377de12ae9ad6e86c2ed9e2160" => :mojave
  end

  depends_on "go" => :build

  def install
    (etc/"gateway-go").mkpath
    system "go", "build", "-mod=vendor", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
    etc.install "gateway-go.yaml" => "gateway-go/gateway-go.yaml"
  end

  plist_options manual: "gateway-go -c #{HOMEBREW_PREFIX}/etc/gateway-go/gateway-go.yaml"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/gateway-go</string>
            <string>-c</string>
            <string>#{etc}/gateway-go/gateway-go.yaml</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/gateway-go.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/gateway-go.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gateway-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/gateway-go init --config=gateway.yml 2>&1")
    assert_predicate testpath/"gateway.yml", :exist?
  end
end
