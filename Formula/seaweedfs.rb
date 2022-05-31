class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.07",
      revision: "fbd99d53c1e45ef12c49ad1ec043c918f4da94e8"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f977b17dac540c611f83b8f1625abdb307ada5536b8aef273cc7b047bef9981e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d08966cf35b67c4eb4329063e9aef373e3e46de53a7df5c5c1829808599d0be"
    sha256 cellar: :any_skip_relocation, monterey:       "d8cd39e47ed7aa9b58d29d0150edb2d4955f8a129ad287e94efeb1a689c9cdfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "3012a78811d1d94e906552f32d241235762825d1471eb16d879f22f6d348284e"
    sha256 cellar: :any_skip_relocation, catalina:       "4130c68dafbb94a1201e636f4a51a9bf48f42c32160361cfe0af953115e84154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4efa9d1c8fee602a7972b6d544ecb657dc90b2d2b43ee5dbec297d5f70fbd4c1"
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
