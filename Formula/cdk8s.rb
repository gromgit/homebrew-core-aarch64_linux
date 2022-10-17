require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.17.tgz"
  sha256 "6e8fc4d45997dc7299701d3f06bf9ba3b02ed61460013fc95056b9d1f726ee97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9fdf1eed868947f71f8bf47dee0af6e5df59016a55c82d115ae5006190ef844"
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
