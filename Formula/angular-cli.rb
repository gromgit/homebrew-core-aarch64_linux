require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.1.1.tgz"
  sha256 "10502199474f7c574f8cdd7e76e581f1c519fed20d9ce9f391278c9e8fdca149"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46ba072f54be8393dda3e3ab0f183150ff755736e0ccf24372dbea9dc0d87b78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46ba072f54be8393dda3e3ab0f183150ff755736e0ccf24372dbea9dc0d87b78"
    sha256 cellar: :any_skip_relocation, monterey:       "78b3ebf4b8537edbb9f5c60d9568d7e8926aab0307914060f899cb82d3531cd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "78b3ebf4b8537edbb9f5c60d9568d7e8926aab0307914060f899cb82d3531cd4"
    sha256 cellar: :any_skip_relocation, catalina:       "78b3ebf4b8537edbb9f5c60d9568d7e8926aab0307914060f899cb82d3531cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46ba072f54be8393dda3e3ab0f183150ff755736e0ccf24372dbea9dc0d87b78"
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
