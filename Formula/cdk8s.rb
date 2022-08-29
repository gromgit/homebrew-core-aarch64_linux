require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.99.tgz"
  sha256 "ba8258b14510c756f74ee0fd6d3a20e0adfb9212216a8f7082eea7b5d4e7d8a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b35b4692f5634b636cdd421e0d33c03753bb4b2423bc3447f9925a1ef2e5dce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b35b4692f5634b636cdd421e0d33c03753bb4b2423bc3447f9925a1ef2e5dce"
    sha256 cellar: :any_skip_relocation, monterey:       "8b35b4692f5634b636cdd421e0d33c03753bb4b2423bc3447f9925a1ef2e5dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "9482fe76131002a8c68b0eb5879fa5a4369f900759ec7846a41db4649a478f21"
    sha256 cellar: :any_skip_relocation, catalina:       "9482fe76131002a8c68b0eb5879fa5a4369f900759ec7846a41db4649a478f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b35b4692f5634b636cdd421e0d33c03753bb4b2423bc3447f9925a1ef2e5dce"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
