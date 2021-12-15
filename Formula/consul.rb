class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "ad644802106e9f78a43f13a10569c59cdb16958850e68a85d73b0e31dfec70e8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "337bf587b80d52344f7a54f362feea72a6abf10272bf31f79992e26899e04f67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44769eae47120a01c8ddc6fed6c9065579b0c51a1f50dcad8c300cdb1254e7cf"
    sha256 cellar: :any_skip_relocation, monterey:       "e60900604b909a2a3ce2f7d1e7131eda6e1744a9b5792d677072fb9661d39641"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1155021f4b267a8827dea43fa7a7253cf00fd788d94ff2375224eb8bb540eb0"
    sha256 cellar: :any_skip_relocation, catalina:       "8d9ab8e9042b692cc6796f0437c7bb8cf905803599a973812075469bc500e22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a344262080c9ada94cf0ea5726fc808a68bb4ddabbeeb96326f0414347edfb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"consul", "agent", "-dev", "-bind", "127.0.0.1"]
    keep_alive true
    error_log_path var/"log/consul.log"
    log_path var/"log/consul.log"
    working_dir var
  end

  test do
    http_port = free_port
    fork do
      # most ports must be free, but are irrelevant to this test
      system(
        bin/"consul",
        "agent",
        "-dev",
        "-bind", "127.0.0.1",
        "-dns-port", "-1",
        "-grpc-port", "-1",
        "-http-port", http_port,
        "-serf-lan-port", free_port,
        "-serf-wan-port", free_port,
        "-server-port", free_port
      )
    end

    # wait for startup
    sleep 3

    k = "brew-formula-test"
    v = "value"
    system bin/"consul", "kv", "put", "-http-addr", "127.0.0.1:#{http_port}", k, v
    assert_equal v, shell_output(bin/"consul kv get -http-addr 127.0.0.1:#{http_port} #{k}").chomp
  end
end
