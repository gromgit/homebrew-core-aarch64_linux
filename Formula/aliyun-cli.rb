class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli/archive/v3.0.65.tar.gz"
  sha256 "eb918d78ac8908b74010993dbd266347e55e9fdc317f2145ed35782dbaf9d253"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbaf48f6f27b9b35ae3162db4171cc166a0fd5da74fc53dfd5380724c122a10d" => :big_sur
    sha256 "a4422b30ac6884c1b0a4cd94af2048fb586a4e947240f225b2a7411b666a67cf" => :arm64_big_sur
    sha256 "aed609ee1b040b3145d49bb723461eaae0e8b6b6cde70094b23fee30c4d29617" => :catalina
    sha256 "30c1452bf8071565f4a7596abb6f3cdb7dbab66987c5a7cc16832ced63b03ec7" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "off"
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{buildpath}/bin"
    (buildpath/"src/github.com/aliyun/aliyun-cli").install buildpath.children
    cd "src/github.com/aliyun/aliyun-cli" do
      system "make", "metas"
      system "go", "build", "-o", bin/"aliyun", "-ldflags",
                            "-X 'github.com/aliyun/aliyun-cli/cli.Version=#{version}'", "main/main.go"
    end
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
