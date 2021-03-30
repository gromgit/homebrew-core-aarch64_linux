require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.2.1.tgz"
  sha256 "d73c146975b704a1159026247fd81b43301b0013812d410946abb16e782b3e76"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "633622c527b99703c0b4067d43d6be83b5ccd5344886c523d140161d4ac43631"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea478bc2f832ee5d51c7d84e062b0278f513b97c0670e405d2c55e536a5ac9cc"
    sha256 cellar: :any_skip_relocation, catalina:      "22a3542e50365dea506886885d2653d1fcec3a2e5fe2a9203835ab09e8c8e4be"
    sha256 cellar: :any_skip_relocation, mojave:        "61b48d301fd9f341058b47003858dd3875c2d0aad6bc387ed4caa9898aebabce"
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
