class Seaweedfs < Formula
  desc "Fast distributed storage system"
  homepage "https://github.com/chrislusf/seaweedfs"
  url "https://github.com/chrislusf/seaweedfs.git",
      tag:      "3.18",
      revision: "475185fb723b50e05f0afe39f7f529302bcee11a"
  license "Apache-2.0"
  head "https://github.com/chrislusf/seaweedfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b25e2917d1d91b6232f030f67ddd00056d91cf2b30e786ef200216c181b0744e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09dc3ffad64a8f75de6744075efa3c74f4944fe59cb56517a59f8e7cf6a4db64"
    sha256 cellar: :any_skip_relocation, monterey:       "7373f25c6d706f540f4a1841a76413e0fc9252bb99c0441d2a6d4a60bd61697c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0ee760ff11eb182adb289d3bef187951152b88d0177fad54d7c5ea568c3076f"
    sha256 cellar: :any_skip_relocation, catalina:       "d973166b6461d182fb3d6583826cc3f18dbcb5b947dad50d0464a68bc50b0550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91316f867ebac6d5a061a2c40ee6126220a915317bedbb00ad731be8d1d63ce"
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
