require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.1.1.tgz"
  sha256 "10502199474f7c574f8cdd7e76e581f1c519fed20d9ce9f391278c9e8fdca149"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2848101fd512a1e61bea0bcafb8f7c3022abe295ab1e3cda5159d1fc3987ac93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2848101fd512a1e61bea0bcafb8f7c3022abe295ab1e3cda5159d1fc3987ac93"
    sha256 cellar: :any_skip_relocation, monterey:       "d93ae4b212353970003c84eb3ad20a7a311518a7bf2f6a815d05a8c3d43bb22c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d93ae4b212353970003c84eb3ad20a7a311518a7bf2f6a815d05a8c3d43bb22c"
    sha256 cellar: :any_skip_relocation, catalina:       "d93ae4b212353970003c84eb3ad20a7a311518a7bf2f6a815d05a8c3d43bb22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2848101fd512a1e61bea0bcafb8f7c3022abe295ab1e3cda5159d1fc3987ac93"
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
