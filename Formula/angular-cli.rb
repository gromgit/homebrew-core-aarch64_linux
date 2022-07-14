require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.0.6.tgz"
  sha256 "e19dec58bea343e6ce84ea2f2c3dda06013c166ba6d0b2b8492ee10699fdcc2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cb3c0bf93efc78ceebfcd7f868a78af51f4d98369e05d7277654419848cd882"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cb3c0bf93efc78ceebfcd7f868a78af51f4d98369e05d7277654419848cd882"
    sha256 cellar: :any_skip_relocation, monterey:       "c9a640b13a13ae32fc90481442138d8aef8fde280df1826a5d2d82757ab7d332"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9a640b13a13ae32fc90481442138d8aef8fde280df1826a5d2d82757ab7d332"
    sha256 cellar: :any_skip_relocation, catalina:       "c9a640b13a13ae32fc90481442138d8aef8fde280df1826a5d2d82757ab7d332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb3c0bf93efc78ceebfcd7f868a78af51f4d98369e05d7277654419848cd882"
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
