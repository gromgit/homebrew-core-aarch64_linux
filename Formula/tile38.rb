class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38.git",
      tag:      "1.29.0",
      revision: "757db4d50904c979a928fcea51166fe9d287a595"
  license "MIT"
  head "https://github.com/tidwall/tile38.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "915a14d364975a895d9ac184e86646031f997c67fd6661e0ade4847d0648096a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c318515963db7dc756b2865d1b7815226ae157cb850a41f2889359bd33e002d1"
    sha256 cellar: :any_skip_relocation, monterey:       "8da844ac221e10d8103fb8dfed5b9d6d5604e3e4f7118cc2e948653c82897bf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8b0186042360ef52f9362b6f157b6e667611e032afc75d6a67b9aef2a24e5bc"
    sha256 cellar: :any_skip_relocation, catalina:       "05b7dbc17c39f33505500a4974b4a0ad0e64273172df11ded26f8fc25511fda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5c116f0e2fe5d6a7b545d287547fdff3c1ca402ef5c9e288891569d8c25a71"
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

  service do
    run [opt_bin/"tile38-server", "-d", var/"tile38/data"]
    keep_alive true
    working_dir var
    log_path var/"log/tile38.log"
    error_log_path var/"log/tile38.log"
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
