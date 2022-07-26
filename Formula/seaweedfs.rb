class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.18",
      revision: "475185fb723b50e05f0afe39f7f529302bcee11a"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3cd923285cba1be13efcfb0de241930e8b6fd782f07c7c5c809510cc56bb5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23a3afa39e4ef0f314ad4d3b1f207c03706c5c3a3efe06ba3e676f943155a34f"
    sha256 cellar: :any_skip_relocation, monterey:       "beb27e1e98eb57464fc7022dc0f716990497015c9d7c088f3e4f0efed6efac72"
    sha256 cellar: :any_skip_relocation, big_sur:        "b043062bc63166e27da1caa226434f2086ac709ae39e98e2b8e0d51dcb6a5c59"
    sha256 cellar: :any_skip_relocation, catalina:       "2bde175d0f3d2421c14894ca2741f8f0d4bb37d16ad96260c8befa9ae60139b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11697bcc9f0a1cc6532e8598ff1dba539e380e20ac7a1f2f5eb5c326117ad537"
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
