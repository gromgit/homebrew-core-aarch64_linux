class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.27",
      revision: "d8ca7d34fe3f83dc1ad174808a2356165e066a15"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22884f0a8e3ae6f685c56f526338c2311bef05b05838849c0549df56bc5d373d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f76b326b39f2f1b4a1d5c12c371ace1dcd4c4071670b774252a094d268e7f910"
    sha256 cellar: :any_skip_relocation, monterey:       "40218b06d7d7f6ce6b8e97405bbdf230051081dad891d6aae13766e59bdb6e6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2bd6573f0bc7c8ac911251bc6fe9694531afaf4c381a19a53d6170e356154b9"
    sha256 cellar: :any_skip_relocation, catalina:       "376ab8438ad35452afc4b95a10c9f33fda8d9b04450e27d46668c61f8b65cd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac8e70bc784d831921655c924412cb3c228ba464735459e5cf61619ddaa822cc"
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
