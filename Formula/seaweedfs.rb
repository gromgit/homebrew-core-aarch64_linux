class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.02",
      revision: "a4ca3ed1f0c2bcde1d36bb48f81dedc3e1924679"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbc529db1a87327284fa0376d1b1579447ec8e79aa5d5ef2e7fffb3bd98b7be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70d427f9154c4db776e5909e42e8e95838e7f1d41a2ae1bd5f7ee6de0c26d72a"
    sha256 cellar: :any_skip_relocation, monterey:       "e33ab21e2c2013582fced7e34428d37c579afe3ebae2c2f5fafe4261226ee457"
    sha256 cellar: :any_skip_relocation, big_sur:        "833414e95f676b8343fbcec802656a311e03cff587ecf17fd3d29bd66f0a0f64"
    sha256 cellar: :any_skip_relocation, catalina:       "0aae83f4a5ceb57e8399138f4e1dbff764a574e3f7b4b4ea4cfc1cda24508c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1cb23db6fd9fef4b626b72fdf6367a30959944c182e8e403753d2d3abad7896"
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
