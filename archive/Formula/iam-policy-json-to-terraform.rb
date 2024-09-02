class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.8.0.tar.gz"
  sha256 "428ee4c7c40a77c3f2c08f1ea5b5ac145db684bba038ab113848e1697ef906dc"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/iam-policy-json-to-terraform"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "46b498ed047128d46b11853208536e679e952f9c3e7cee7a2b0ef76e7d675e53"
  end

  # Bump to 1.18 on the next release.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = pipe_output("#{bin}/iam-policy-json-to-terraform", test_input)
    assert_match "ec2:Describe*", output
  end
end
