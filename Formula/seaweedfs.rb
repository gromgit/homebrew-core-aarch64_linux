class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.29",
      revision: "1ffb1e696e1f651c6294fc34c86b9abb6db1985d"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8e2f56cf5271ebe1dfa532caa50f0f04513fe6088cede166d1722802120140b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3b9e20d8029d83c306110e401fd6f8b3fde6014b22941be3b377910ec52c03d"
    sha256 cellar: :any_skip_relocation, monterey:       "c79628f6a86215e8dd4d888540f2b5510a2148ec8aa2a51b160184eec985943f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f90e1b1d9e594329ce26674ca570b2e53b1af9834d7b67cbb0b10e09a1f50e1"
    sha256 cellar: :any_skip_relocation, catalina:       "e3ecae9d4c3d013db879a43f9884b313d6b31ef6c7ab87fdc089418ad700cffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "795a9151408fa55deb2b2da96567444411bb46e3f5ec6be5bc6131be508ec993"
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
