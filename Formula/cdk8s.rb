require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.54.tgz"
  sha256 "40888a5e141ca678b402744398cc071c64670c025d33c5fb2c8db451e9212080"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b2d56d6a02591abccbe154bb23b55bd3e94bed45d6fdce28c2860e995e242f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b2d56d6a02591abccbe154bb23b55bd3e94bed45d6fdce28c2860e995e242f6"
    sha256 cellar: :any_skip_relocation, monterey:       "0b2d56d6a02591abccbe154bb23b55bd3e94bed45d6fdce28c2860e995e242f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a61d83250b6f38f12dca8f053c0b7cd165694c321a6e536a0990965f65468024"
    sha256 cellar: :any_skip_relocation, catalina:       "a61d83250b6f38f12dca8f053c0b7cd165694c321a6e536a0990965f65468024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2d56d6a02591abccbe154bb23b55bd3e94bed45d6fdce28c2860e995e242f6"
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
