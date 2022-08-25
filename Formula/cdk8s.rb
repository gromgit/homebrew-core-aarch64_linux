require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.94.tgz"
  sha256 "ec85a203c84a2f85b282391f7eaafbfda2e3f7ef570f07de10715eefdaac48ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a5841bfc0cfba151b0caeddbe8f4d2370cf92b3eb77293ebadceb004b3567ae"
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
