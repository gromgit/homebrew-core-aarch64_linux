class GatewayGo < Formula
  desc "GateWay Client for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub"
  url "https://github.com/OpenIoTHub/gateway-go.git",
      tag:      "v0.1.91",
      revision: "8df96b8ae676344c14277c61ee8ac8bb206d8ef9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d500da2cfd4440756069ef3468175f05dcac6466f6aad7122422000b99626b24" => :catalina
    sha256 "320e57d993cbf1dcaf2faa8aaecb0dba6927750cbd993c1b6e3b3113788233ca" => :mojave
    sha256 "68d32263ef725bd5e4af6e8149032877223d8a10c1e2a9b2bde5cd3f88408b16" => :high_sierra
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
