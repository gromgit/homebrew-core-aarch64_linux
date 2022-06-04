class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.117",
      revision: "40a9f965757462073991abbd99d62534f1c30fb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "109c0290d096e52d99201d28a81f54e7291b4dd35e3b1b3b8b172fb9b7965113"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28244d94e363076968fb8bfff8bc8517850402d3c68103bd8ffbe310bb967ac7"
    sha256 cellar: :any_skip_relocation, monterey:       "cd7eee9e996815db4160697178a72c43facba0c5fceb362f3c77535d39f2e478"
    sha256 cellar: :any_skip_relocation, big_sur:        "daabb27e17f343d0197b50c8534290544b829c633bd83863d8afded4e1eddf53"
    sha256 cellar: :any_skip_relocation, catalina:       "7d58b170218eacaee1e64c21aa37f11666b234c877389a0488d2854bd63418d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17bcc4d3f1211cc8303bb55fb92e21c8ecfff0c5455893e95b4d2de7c51a1292"
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
