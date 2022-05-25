class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.121",
      revision: "624846497c415f00e0a652e0a386c916068f21c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ed4d172115c45e01a9cd2ed32720150895ea45572450e962329e5be45fbbd3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8b11cc6bd54506585b184d8d80545ef6da08691dd71c6c70195f7e0d70d053f"
    sha256 cellar: :any_skip_relocation, monterey:       "46c7ae2563d7b51c426264681bd8776e6a69bd3c33beb65381a6b575b0b07e02"
    sha256 cellar: :any_skip_relocation, big_sur:        "c354e7e12849104b1bed9126d5c7c1f989bf68092d710ed5c9a28d3970eef72f"
    sha256 cellar: :any_skip_relocation, catalina:       "808f1ba7c09ac06e0fcc43fd46bd08ef4bc71634e389aeb2db6f931cf91a581f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb76ea12a49dfce5799906f22a23f5787c0b4471f411b6122d3152b11cd35a76"
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
