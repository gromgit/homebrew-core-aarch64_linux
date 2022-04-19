class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "2.99",
      revision: "8e98d7326b8cbd715033ec5a0e602732a4034850"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9588a27fdc3a39664e4d5516f811594fb0c24d71022783609e82d352405fa1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f15747eb5106a5e0dbcb87a5523dc35b03526110670e9aedfea27dfb6b4e386"
    sha256 cellar: :any_skip_relocation, monterey:       "a208464b07fdedd857b48564778580b385e73ef41a03269fab1b4b1d62c4e0aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "34ef2eafcaa39550ee0d8e9319fb85195f580a847edb04fba8c593959eeca792"
    sha256 cellar: :any_skip_relocation, catalina:       "d5f98fb031f2319c96022ac84b09ede73e4d40eda89d576f26c2c1d6733d1cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cec458685db9b66992a968a62d35ce35180e739f7662c3870f9d049e344d381d"
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
