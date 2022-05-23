class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.06",
      revision: "2f846777bbceea307771e79d4452e071b0bd5a51"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8384e9bda542799099710ebec78ad5f9551fd7547968b9c0bec7ce848b37c69b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3bc7c9904ceddba23fb647862b9027ecd49771dd9c2073a46855c9b1fe55206"
    sha256 cellar: :any_skip_relocation, monterey:       "07449c689d5a04533bccde5666d865deca850f3373ccf8e4b13d3a16c73c35e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf05ee60877fefdf7219cf7ea8fb3949a72cafbe3e5f9e34099bbebfffa0b68f"
    sha256 cellar: :any_skip_relocation, catalina:       "6de6652f3fe002ce27fa951d811365577d59a01b16774fb4f9fbaa75475d8e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87c17cc4f51fb22eac0b2e974df185d5683c85f163149d5aa0d2bfedab445859"
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
