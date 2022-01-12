class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.103",
      revision: "ce2fded4607e5aca33a4c77e0afd90aee1093f23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd905d71204fb0ef7f5387cc1366c2cfc7dde38eda28c2b0f05dccb25f9c8d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "120f1cc5d2600c01f4609a07c4d50a42423b446cd28780f2c2ac27cd601413c4"
    sha256 cellar: :any_skip_relocation, monterey:       "7c67686e8101334dfa3d9e495f937e15f5f96e19c4b7c454468f43571ed1918c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4f3640b58b35746a3f36237a2a5e45a4c12171be434c26f401b72962e096b6b"
    sha256 cellar: :any_skip_relocation, catalina:       "442dc34cd3062210cea4f1e52e45bfe8657622fa07bdd4aa6212c506ed4d87af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "579dbe7c57b8cb29b552be43c637b39275133c26664c527fdd03384edb33f1a3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"),
                          "-o", bin/"aliyun", "main/main.go"
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
