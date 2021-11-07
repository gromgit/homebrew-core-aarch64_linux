require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.24.tgz"
  sha256 "660a03a954e97fcc1dd4b24cacf12efefd6c9047c52d0fa4fb0a441b1cf52f4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cd5191defce96b11445dc6382afefc29a0a16e458e18ee2d4ee20955af36f4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cd5191defce96b11445dc6382afefc29a0a16e458e18ee2d4ee20955af36f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "1cd5191defce96b11445dc6382afefc29a0a16e458e18ee2d4ee20955af36f4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cd5191defce96b11445dc6382afefc29a0a16e458e18ee2d4ee20955af36f4b"
    sha256 cellar: :any_skip_relocation, catalina:       "1cd5191defce96b11445dc6382afefc29a0a16e458e18ee2d4ee20955af36f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cd5191defce96b11445dc6382afefc29a0a16e458e18ee2d4ee20955af36f4b"
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
