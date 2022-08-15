class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.21",
      revision: "7c029b21832682e27bbac5a310323a7aeed6afe9"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e74522a50a0c5591bc7f3066f5c4ff564d33bc4f1eece8afd8f13aa01b8d11e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d73a604be84ac91f77171566e564004cdca53c4b64c5c3f38a388b29cfe4aba"
    sha256 cellar: :any_skip_relocation, monterey:       "20bfee045b17789670bafc150e61f2a44844e5adc3e3d316a02db04d6e5713e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ea14295f9b5f0594861da96a61c0db621c9ddfbf74dd7eb8c07e5fbb09bd18c"
    sha256 cellar: :any_skip_relocation, catalina:       "ec58a0f230fa4cef5cde9b15e4d94025c86dfce60d550c4cb0842f3e16056075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1d932c5006074f1448edede04f25d4f715f0ac9e936d583824874a3fb11a82"
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
