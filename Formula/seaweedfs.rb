class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.23",
      revision: "c4e862e90852de651aa0c6e7cbe16789be9d5d28"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ab8ec2d56f004ce539bc93956da94d0551d91bad3955cab48398e8df92c597c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b127a78a6946e57e9ac752939023919a8dff797eb20a37878757e3890b1b75b"
    sha256 cellar: :any_skip_relocation, monterey:       "d8a511722e005f4c5ddfdbfe02a37ba465b0827e1f76adbea8802762300b8c86"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0259b810f4620910434e66e85bd9a11f27cd3af604fa3d39a0b4c3beb095db2"
    sha256 cellar: :any_skip_relocation, catalina:       "5e18074380d209d553eabb4d9a36fa7e16c6a7464f3d9341aefa913b1045f68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1999f9f5a52f8c9b2355c5e06dd883547a8688bb3474c3af0a7d1b9d24e931b8"
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
