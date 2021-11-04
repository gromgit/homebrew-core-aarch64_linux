require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.0.1.tgz"
  sha256 "eb6d7042f1c78b9b462dae4363bce13605ac8ae823e663503e087fa89dd24092"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f46af275a7c1adc054247ec0cf11c20e83446f8bd1e7aa3ad62417491f438ade"
    sha256 cellar: :any_skip_relocation, big_sur:       "8708ee2eec7756191a83e0d918a041f376c11097423e9f85e2320935df9999ea"
    sha256 cellar: :any_skip_relocation, catalina:      "8708ee2eec7756191a83e0d918a041f376c11097423e9f85e2320935df9999ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46af275a7c1adc054247ec0cf11c20e83446f8bd1e7aa3ad62417491f438ade"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
