class Dtm < Formula
  desc "Cross-language distributed transaction manager"
  homepage "https://en.dtm.pub/"
  url "https://github.com/dtm-labs/dtm/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "01d338ea805c76ee78cb76aa2713d1eb846df8d82209edc985c32d06e201efe7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2e64ef8c17d5611d039b5e7ced1deacc6601fac51da2606c8dac8f606f43b30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26a1e0e1175abffeeb1c71f6f943a072ab5741ac3c80e51944307bdb1089d71c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "010bc9a494d26fc1f0c8369c9e8bf988dc6ccb0f33768c89a73df71a0f8d6cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7dcc64279dc17224b2d1639d2986dbd4e61e29e2293855acb4bcfd4e21b335"
    sha256 cellar: :any_skip_relocation, big_sur:        "512ba48c27b45f3de912c94baaf40d3cba0578e8f0a985d99b5d1b386b2aacc0"
    sha256 cellar: :any_skip_relocation, catalina:       "2dc389ae422224c9deec7fcbf403360dd799b4448663b7ab5a8e2f942ae67838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01544afbe5b249b1493344efd72bd34507f3d2408b944cb4da9dcd7144118170"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"dtm-qs"), "qs/main.go"
  end

  test do
    assert_match "dtm version: v#{version}", shell_output("#{bin}/dtm -v")

    http_port = free_port
    grpc_port = free_port

    dtm_pid = fork do
      ENV["HTTP_PORT"] = http_port.to_s
      ENV["GRPC_PORT"] = grpc_port.to_s
      exec bin/"dtm"
    end
    # sleep to let dtm get its wits about it
    sleep 5
    metrics_output = shell_output("curl -s localhost:#{http_port}/api/metrics")
    assert_match "# HELP dtm_server_info The information of this dtm server.", metrics_output

    all_json = JSON.parse(shell_output("curl -s localhost:#{http_port}/api/dtmsvr/all"))
    assert_equal 0, all_json["next_position"].length
    assert all_json["next_position"].instance_of? String
    assert_equal 0, all_json["transactions"].length
    assert all_json["transactions"].instance_of? Array
  ensure
    # clean up the dtm process before we leave
    Process.kill("HUP", dtm_pid)
  end
end
