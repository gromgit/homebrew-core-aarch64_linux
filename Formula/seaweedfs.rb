class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.17",
      revision: "33cff6199219f4f8cb099fd95fdc8612cb32f562"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa8b007592927f66340bf1dd0e18d4c9706433db7fe43d7f5eaebb2c8a08547d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "095f0ee971215e9ac18880fc55ebf2d7e03cb438bbc7d30dac65ce55069ce08e"
    sha256 cellar: :any_skip_relocation, monterey:       "70a10b4fd11d5a0640b1b644ff3880781acbc64b2aaa1c47ed7b4a6ed5752de0"
    sha256 cellar: :any_skip_relocation, big_sur:        "103bd4c276d53649d7b53904103489f3497a73752e4f732d50c642d4c16074dd"
    sha256 cellar: :any_skip_relocation, catalina:       "0a5a59b1e017a87c391c78829a07b1a0af04d6a464508abf1043626b3b8935b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e48267a94ba857ef72d8ea387f7fb7bf0bd9387790f0ee864ff7fa51f38b26c3"
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
