require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.28.0.tgz"
  sha256 "a31f7fbabd2ded1c5c193927b5a947c90f08e64f62fddd072c8a4372c1ddf23a"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "858e6cf32b1239e12a521e52800fd3b22c933a05a7d69d40310736fbdbe31a19" => :catalina
    sha256 "4cdd3297c5836fe29b1cae7113378c621daebe25edda1bf90672cfdc1968cfc9" => :mojave
    sha256 "9e3afef889b83666cead1be549c8b7c4e4d4ffd2f0ad269986033cd44f149585" => :high_sierra
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
