class CfnFormat < Formula
  desc "Command-line tool for formatting AWS CloudFormation templates"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v1.2.0.tar.gz"
  sha256 "064bc2b563c9b759d16147f33fe5c64bf0af3640cb4ae543e49615ae17b22e01"
  license "Apache-2.0"

  livecheck do
    formula "rain"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cfn-format"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3b0cdae914af72dd61c4ebefab20eebcc2d805606db9eff2dfd4e180ae793cad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/cfn-format/main.go"
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: formatted OK", shell_output("#{bin}/cfn-format -v test.template").strip
  end
end
