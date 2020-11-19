class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.5.0.tar.gz"
  sha256 "9d58642d3f532c4334dc63f45e44ff9cae254360f977bca925f20033338fadcb"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4937929d8440ae240e41db53131c388bbd7060e11bc0f72a304bcc34ce5b8eeb" => :big_sur
    sha256 "a331e44477c92d026cad6d7bdb2865c82fd88813225bfeab5223d1da5d88e7fb" => :catalina
    sha256 "b81637d334ede30f8fe183ca74ecbf43aadf355f09c001737d69edf56dc36d2c" => :mojave
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/flosell/iam-policy-json-to-terraform"
    dir.install buildpath.children
    cd "src/github.com/flosell/iam-policy-json-to-terraform" do
      system "make", "iam-policy-json-to-terraform_darwin"
      mv "iam-policy-json-to-terraform_darwin", "iam-policy-json-to-terraform"
      bin.install "iam-policy-json-to-terraform"
    end
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = shell_output("echo '#{test_input}' | #{bin}/iam-policy-json-to-terraform")
    assert_match "ec2:Describe*", output
  end
end
