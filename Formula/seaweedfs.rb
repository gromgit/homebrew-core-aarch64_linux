class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.14",
      revision: "3c79c770562ef4f7c0d4e57a88f616eb3671b9cd"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55229c92e37449e51c721117bc74be5ca27fa273af08cce3d86447c162c793fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95dad725b728783dc647cdbea3ab803bd1156f368d5b9978d61605532c322cfe"
    sha256 cellar: :any_skip_relocation, monterey:       "1059d456bfb3085f5a57b5291a2093629f040dd35508cd107f59a13e638fa575"
    sha256 cellar: :any_skip_relocation, big_sur:        "733367c54a8e11e97dcbe7e0a2b55110721c20a427fe9d47391f2983355fa2b1"
    sha256 cellar: :any_skip_relocation, catalina:       "29ce3666e7868ffd46116c35943e9d4057d3889916b06f07013d960546dcfc0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ed78383c73097c2b9aa399dcdc53911bfd223a61eb66ec94f1c5bbd2ed0e78"
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
