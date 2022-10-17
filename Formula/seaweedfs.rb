class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.32",
      revision: "758d70bdc09834066cfd835d0041f38ac77a1d42"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "501d2981efd7820eebe1fe733b79455853393df74eea03b1f3bc263135fac632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "366be67741f42faefdf9462f8e19b4d2ea922d9acc5e17ce53e39313796d9e14"
    sha256 cellar: :any_skip_relocation, monterey:       "c861bfa5865d4cc28ca809865c3892b015bb4c9aebd1f06f63e0fea7fbaedb2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e377d73db33bb3326953dbbfc98f62de58737ef5e18170cf5d0a0e7cd6e99f64"
    sha256 cellar: :any_skip_relocation, catalina:       "2697066bbf745bf6ce2c1b8e12f27fa1b06cf752465f68475327d2699f9cbb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0c86f71974ea1135a7ef78a615b3551730506bc2c06bcca012124684894930"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chrislusf/seaweedfs/weed/util.COMMIT=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(output: bin/"weed", ldflags: ldflags), "./weed"
  end

  test do
    # Start SeaweedFS master server/volume server
    master_port = free_port
    volume_port = free_port
    master_grpc_port = free_port
    volume_grpc_port = free_port

    fork do
      exec bin/"weed", "server", "-dir=#{testpath}", "-ip.bind=0.0.0.0",
           "-master.port=#{master_port}", "-volume.port=#{volume_port}",
           "-master.port.grpc=#{master_grpc_port}", "-volume.port.grpc=#{volume_grpc_port}"
    end
    sleep 30

    # Upload a test file
    fid = JSON.parse(shell_output("curl http://localhost:#{master_port}/dir/assign"))["fid"]
    system "curl", "-F", "file=@#{test_fixtures("test.png")}", "http://localhost:#{volume_port}/#{fid}"

    # Download and validate uploaded test file against the original
    expected_sum = Digest::SHA256.hexdigest(File.read(test_fixtures("test.png")))
    actual_sum = Digest::SHA256.hexdigest(shell_output("curl http://localhost:#{volume_port}/#{fid}"))
    assert_equal expected_sum, actual_sum
  end
end
