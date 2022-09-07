class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.26",
      revision: "c07ab9c060eafe26cc0b4246d507d5b33f32f317"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f6b059a7ac2316ceae645ef057de900a8c0267000f0e19e7476b0375fd66434"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f7b1e9e7497a72bab7a00a0f92418cd4a7c637eec7e578c47e72c06e56ba9df"
    sha256 cellar: :any_skip_relocation, monterey:       "a9a643f774abdc78d216049ba8575717f167852b9563f59614bd58acc485c4df"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4aa18219640de9e485e38399b6dcfe1c4901f24ed0af54972aacc816f1dbe9d"
    sha256 cellar: :any_skip_relocation, catalina:       "c560bde142433c68a715a2186e170264a42f11bca2bdc76e80abf8e404fa9dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8379cf2d37bc37669f3dc6923c978f87e0c04ecfae8970a89bebf743d7b50edd"
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
