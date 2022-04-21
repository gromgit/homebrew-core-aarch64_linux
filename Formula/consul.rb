class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "87b3fe01d0a772dc1cbab31cf38ab05d651d93cd1632aa289faf06988a65d617"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3667382cf412694661f97d636b08ce799127254169d2b1c60a2319c03a120eaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc88dea3cc27e0e5272a712b57a5be55e4878e3a8dd1831b13e1c7be297922b1"
    sha256 cellar: :any_skip_relocation, monterey:       "7ebca46d1d8edaba1ae5ff3b95013fb7513e5b1f386a7f87c3454909c050cec1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bdc2315fb1b3bdf63bf461874d1ef3bb29258f686b9f86b6b728e1a55fc1c69"
    sha256 cellar: :any_skip_relocation, catalina:       "074a91900bdb2d5f7aacffed85c8e0ac023ad55dcc294e5820f323234010de2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59a02c32512edca00afd518506d4f7ee77d6b6f5e241898207d2daa3841ff7b6"
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
