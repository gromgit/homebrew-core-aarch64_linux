class Sdns < Formula
  desc "Privacy important, fast, recursive dns resolver server with dnssec support"
  homepage "https://sdns.dev"
  url "https://github.com/semihalev/sdns/archive/v1.1.5.tar.gz"
  sha256 "1b874b5fe86e16a11f476f0c1626a9d5bca34e5d03759b6208a5311ae785edd3"
  license "MIT"
  head "https://github.com/semihalev/sdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cee8c42148b4128465ea3305548bc9824fd53d14de391e679f3ee0f55640def" => :catalina
    sha256 "9a2f0df5b3fc9b9dc9b42c7023d22ad22c34a4d5d2d347ae6fd8ad61e1344602" => :mojave
    sha256 "41edd8b283682e17445dee3279ead478050b6fba75265351b2f51ce5a697152b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "sdns"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/sdns</string>
            <string>-config</string>
            <string>#{etc}/sdns.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/sdns.log</string>
          <key>WorkingDirectory</key>
          <string>#{opt_prefix}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    fork do
      exec bin/"sdns", "-config", testpath/"sdns.conf"
    end
    sleep(2)
    assert_predicate testpath/"sdns.conf", :exist?
  end
end
