class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.25.1",
      revision: "6e52e3a7eb49266b5c91d31debf44d2038892ebf"
  license "MIT"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f885a351d2b12fb8088ef34f744cbfbfcd44964be0072e8cd8ad8c828f1d6017"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a03ec1ecd38ffe545f48d940dc7c0d048e368d3af4209baa5b20f652a0d85ae"
    sha256 cellar: :any_skip_relocation, catalina:      "5bbbf9482a19c252cbf5a275e608fbda0fb2c92651e41fcbfd2f351aa326b757"
    sha256 cellar: :any_skip_relocation, mojave:        "261862ae6a512b7abb448afdb7ff99a8ee3d407d4969461ad85f75a4f4686597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91112b409a6ea318e969a420c2a6d150dd20081139086ff45bef748dbf93466a"
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/tidwall/tile38/core.Version=#{version}
      -X github.com/tidwall/tile38/core.GitSHA=#{Utils.git_short_head}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-server", "./cmd/tile38-server"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"tile38-cli", "./cmd/tile38-cli"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats
    <<~EOS
      To connect: tile38-cli
    EOS
  end

  plist_options manual: "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/tile38-server</string>
            <string>-d</string>
            <string>#{datadir}</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/tile38.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/tile38.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/tile38-server", "-q", "-p", port.to_s
    end
    sleep 2
    # remove `$408` in the first line output
    json_output = shell_output("#{bin}/tile38-cli -p #{port} server")
    tile38_server = JSON.parse(json_output)

    assert_equal tile38_server["ok"], true
    assert_predicate testpath/"data", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end
