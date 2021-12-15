require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.8.3.tgz"
  sha256 "4cc0d24a24c5c1ded68a8325dcdd3b57fd0af34531292d5ba2a794ae898ad1eb"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d751cb7b22682b1731c73f16f6a413fdb3093f5f2cc9acb158c67bb35f96f2fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d751cb7b22682b1731c73f16f6a413fdb3093f5f2cc9acb158c67bb35f96f2fa"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b379dfc8dbf5a5f7dd7fdb3e0e4194684cc71312aa2a7c973b9fe81c81d768"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b379dfc8dbf5a5f7dd7fdb3e0e4194684cc71312aa2a7c973b9fe81c81d768"
    sha256 cellar: :any_skip_relocation, catalina:       "f5b379dfc8dbf5a5f7dd7fdb3e0e4194684cc71312aa2a7c973b9fe81c81d768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d751cb7b22682b1731c73f16f6a413fdb3093f5f2cc9acb158c67bb35f96f2fa"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
