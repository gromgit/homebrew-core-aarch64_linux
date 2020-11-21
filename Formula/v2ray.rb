class V2ray < Formula
  desc "Platform for building proxies to bypass network restrictions"
  homepage "https://v2fly.org/"
  url "https://github.com/v2fly/v2ray-core/archive/v4.32.1.tar.gz"
  sha256 "f5553ffd04ff226573e8132d9beaa63f4d8f4882eba047225b33620848bc6917"
  license all_of: ["MIT", "CC-BY-SA-4.0"]
  head "https://github.com/v2fly/v2ray-core.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7496d6ae48dd62d0c27279dcea0c8e326f271214130c789b6e435352e5fcba6c" => :big_sur
    sha256 "a6909a3609af1306b6907ab3541856a1dfe9334cdf06e0c86b0707778b02fb83" => :catalina
    sha256 "bb943e8f9927dd164bdbe6b0236a009d99966ddccf04ef91ef982df2fcf734c0" => :mojave
  end

  depends_on "go" => :build

  resource "geoip" do
    url "https://github.com/v2fly/geoip/releases/download/202011150541/geoip.dat"
    sha256 "11b7c3bfc5715c42d26b0e4bcf51d38c157eae9ab4b9e8391d702681e385dbcd"
  end

  resource "geosite" do
    url "https://github.com/v2fly/domain-list-community/releases/download/20201117215431/dlc.dat"
    sha256 "32ba60cb90c9f6951e2de12bf3a8e9fd5fbccee4d1706421f1a9413303e75a2e"
  end

  def install
    ldflags = "-s -w -buildid="
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "./main"
    system "go", "build", *std_go_args,
                 "-ldflags", ldflags,
                 "-tags", "confonly",
                 "-o", bin/"v2ctl",
                 "./infra/control/main"

    pkgetc.install "release/config/config.json" => "config.json"

    resource("geoip").stage do
      pkgshare.install "geoip.dat"
    end

    resource("geosite").stage do
      pkgshare.install "dlc.dat" => "geosite.dat"
    end
  end

  plist_options manual: "v2ray -config=#{HOMEBREW_PREFIX}/etc/v2ray/config.json"

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
            <string>#{bin}/v2ray</string>
            <string>-config</string>
            <string>#{etc}/v2ray/config.json</string>
          </array>
          <key>KeepAlive</key>
          <true/>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "log": {
          "access": "#{testpath}/log"
        },
        "outbounds": [
          {
            "protocol": "freedom",
            "tag": "direct"
          }
        ],
        "routing": {
          "rules": [
            {
              "ip": [
                "geoip:private"
              ],
              "outboundTag": "direct",
              "type": "field"
            }
          ]
        }
      }
    EOS
    output = shell_output "#{bin}/v2ray -c #{testpath}/config.json -test"

    assert_match "Configuration OK", output
    assert_predicate testpath/"log", :exist?
  end
end
