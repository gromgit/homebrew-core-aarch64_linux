class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.127",
      revision: "0afd3fbe0cbc1b6a375add45ed896454c21cd53f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a680a7515411a8134119b682877a9f70c4d703bb1e078d9ab2270875f059a3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efe6d85d15458a543c8da9b43425b77b275fca1b009971208decee48c36363c2"
    sha256 cellar: :any_skip_relocation, monterey:       "772e0e9ff92b034b28cf4d6f8616878947a944460cb0d983700467f00caeb8c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "14c792cb7fe96b4947205e29bad5b3ba4d6cc4a598b7d0b07129adbee0a95d68"
    sha256 cellar: :any_skip_relocation, catalina:       "390761c05c3eb85ce34ad597298f8dcb39e6f4b393073e6b9877476a34a25889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6687e8b852c212d3d50444d7120e2eb67c6bc9e9747794c0efe0655f4aa51bf4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
