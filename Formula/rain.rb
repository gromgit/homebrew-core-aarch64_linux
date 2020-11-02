class Rain < Formula
  desc "Command-line tool for working with AWS CloudFormation"
  homepage "https://github.com/aws-cloudformation/rain"
  url "https://github.com/aws-cloudformation/rain/archive/v0.10.2-1.tar.gz"
  sha256 "a3c855cef9aae00f28c9b39d70d1df0c94e965a389ae38c4dd0d5b07a5fea6bc"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "46dc6c9859a50f9808384453d34d3f1424d08d3d21c062826e29fb8549968e92" => :catalina
    sha256 "e753441f3386634d0b31e67f31caafedcb2291f21f249f649cb32c752b0453f0" => :mojave
    sha256 "ba6425b263d3ab95baa5214d89b966bb3f481dc0fb7848dcb0a2b34f47e8a732" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.template").write <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    EOS
    assert_equal "test.template: ok", shell_output("#{bin}/rain check test.template").strip
  end
end
