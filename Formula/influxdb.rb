class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      tag:      "v2.0.7",
      revision: "2a45f0c0375a7d5615835afa6f81a53444df9cea"
  license "MIT"
  revision 1
  head "https://github.com/influxdata/influxdb.git"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a3f13018e62fedf8be455e9ab107ffcefe389fb2cc413616313916b6ae5c191"
    sha256 cellar: :any_skip_relocation, big_sur:       "1743eabe01d8b83324a122c3924aec0fa3df10fe95662a57c1c01f95de1241c0"
    sha256 cellar: :any_skip_relocation, catalina:      "f05b7fc3b7968b88ed86009e965ddaa63236987247e5c0e5c049015b8d4d2b35"
    sha256 cellar: :any_skip_relocation, mojave:        "757e3bb54d32c90e98dd6e612c3621b719b77e2b08649f14f0b0f772b455dde2"
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.7.tar.gz"
    sha256 "9bfe2c06b09fe7f3274f4ff8da1d87c9102640285bb38dad9a8c26dd5b9fe5af"
  end

  # NOTE: The version/URL here is specified in scripts/fetch-ui-assets.sh in influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "ui-assets" do
    url "https://github.com/influxdata/ui/releases/download/OSS-v2.0.7/build.tar.gz"
    sha256 "5aebccacb2e13d9fffd1cbca567f63791f3c19be2088045bdbcd38100381101a"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    # Extract pre-build UI resources to the location expected by go-bindata.
    resource("ui-assets").stage(buildpath/"ui/build")

    # Embed UI files into the Go source code.
    system "make", "generate"

    # Build the CLI and server.
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{Time.now.utc.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags),
           "-o", bin/"influx", "./cmd/influx"
    system "go", "build", *std_go_args(ldflags: ldflags),
           "-tags", "assets", "-o", bin/"influxd", "./cmd/influxd"

    data = var/"lib/influxdb2"
    data.mkpath

    # Generate default config file.
    config = buildpath/"config.yml"
    config.write Utils.safe_popen_read(bin/"influxd", "print-config",
                                       "--bolt-path=#{data}/influxdb.bolt",
                                       "--engine-path=#{data}/engine")
    (etc/"influxdb2").install config

    # Create directory for DB stdout+stderr logs.
    (var/"log/influxdb2").mkpath
  end

  plist_options manual: "INFLUXD_CONFIG_PATH=#{HOMEBREW_PREFIX}/etc/influxdb2/config.yml influxd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>INFLUXD_CONFIG_PATH</key>
          <string>#{etc}/influxdb2/config.yml</string>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/influxd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/influxdb2/influxd_output.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/influxdb2/influxd_output.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    ENV["INFLUXD_BOLT_PATH"] = "#{testpath}/influxd.bolt"
    ENV["INFLUXD_ENGINE_PATH"] = "#{testpath}/engine"

    influxd_port = free_port
    influx_host = "http://localhost:#{influxd_port}"
    ENV["INFLUX_HOST"] = influx_host

    influxd = fork do
      exec "#{bin}/influxd", "--bolt-path=#{testpath}/influxd.bolt",
                             "--engine-path=#{testpath}/engine",
                             "--http-bind-address=:#{influxd_port}",
                             "--log-level=error"
    end
    sleep 20

    # Check that the CLI works and can talk to the server.
    assert_match "OK", shell_output("#{bin}/influx ping")

    # Check that the server has properly bundled UI assets and serves them as HTML.
    curl_output = shell_output("curl --silent --head #{influx_host}")
    assert_match "200 OK", curl_output
    assert_match "text/html", curl_output
  ensure
    Process.kill("TERM", influxd)
    Process.wait influxd
  end
end
