require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.1.1.tgz"
  sha256 "0a136f126fa14387f077f9f1c413c9c3fb705ee6a3635e207b280413d2ed96b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2381d8b38493f51232c8450dbcb268089616e829c56bf6d5875f3d603a238ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2381d8b38493f51232c8450dbcb268089616e829c56bf6d5875f3d603a238ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "796a0283af02ed891eec1a0e54339cf81c539ab00fcc5b27a056e9544800d3fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "796a0283af02ed891eec1a0e54339cf81c539ab00fcc5b27a056e9544800d3fd"
    sha256 cellar: :any_skip_relocation, catalina:       "796a0283af02ed891eec1a0e54339cf81c539ab00fcc5b27a056e9544800d3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2381d8b38493f51232c8450dbcb268089616e829c56bf6d5875f3d603a238ae2"
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
