require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.0.4.tgz"
  sha256 "b81c513a4a9fbbc6a43a61767f0fc91ae998588cef6ceb5398d5075b2eaad3d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "840e1486f654ebbcd2a2705aa8b585e958da63d2f79cd2d644a5f0a547d3116e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "840e1486f654ebbcd2a2705aa8b585e958da63d2f79cd2d644a5f0a547d3116e"
    sha256 cellar: :any_skip_relocation, monterey:       "3d1b763ab5bc582bb9df6c23863c7eeb7e6bef3f6b460ed75fbddf2bf514574a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d1b763ab5bc582bb9df6c23863c7eeb7e6bef3f6b460ed75fbddf2bf514574a"
    sha256 cellar: :any_skip_relocation, catalina:       "3d1b763ab5bc582bb9df6c23863c7eeb7e6bef3f6b460ed75fbddf2bf514574a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "840e1486f654ebbcd2a2705aa8b585e958da63d2f79cd2d644a5f0a547d3116e"
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
