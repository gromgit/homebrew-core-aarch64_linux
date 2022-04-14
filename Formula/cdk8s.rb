require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.147.tgz"
  sha256 "23d00a126a70546f67fbb0912aaa863d830b13a388ebc762f67b45b118261e4c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "061cd08844f6d12c501cd6560588a062f031ffb847fb964a5602dfd312e99a6b"
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
