class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.3.0.tar.gz"
  sha256 "90b5be7caa232186718b5645b2d5ab65a59695854db7598462bdbe059444a051"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef3fc3988992318aaba7c08cdf0673c926582a5702fefe41bde207d6b8ab0334" => :catalina
    sha256 "2cdd8319c8b2b24bd5ab168dc3cbd4b73085e5f943e129c295564ba03052dc88" => :mojave
    sha256 "910972e266cff1247565ad9eed6a50ad3c146ca0c6b948953dfe02b48225c7c8" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"

    dir = buildpath/"src/github.com/flosell/iam-policy-json-to-terraform"
    dir.install buildpath.children
    cd "src/github.com/flosell/iam-policy-json-to-terraform" do
      # system "go", "build", "-o", "iam-policy-json-to-terraform", "*.go"
      system "make", "iam-policy-json-to-terraform_darwin"
      mv "iam-policy-json-to-terraform_darwin", "iam-policy-json-to-terraform"
      bin.install "iam-policy-json-to-terraform"
      prefix.install_metafiles
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
