require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.1.2.tgz"
  sha256 "a1cd06426e961bc4c4980f6ddfdfd81dbf1cb34f329b0234d432db27a6050bd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "01dd03fa9e2e514e99964ec3d70330c5f908557cc9c07d368ba826fe30a5d9be"
    sha256 cellar: :any_skip_relocation, big_sur:       "228ca30be9c64fad1311b773860758cb3a9538fc25b5bf0fdee51e24b2f8b122"
    sha256 cellar: :any_skip_relocation, catalina:      "228ca30be9c64fad1311b773860758cb3a9538fc25b5bf0fdee51e24b2f8b122"
    sha256 cellar: :any_skip_relocation, mojave:        "228ca30be9c64fad1311b773860758cb3a9538fc25b5bf0fdee51e24b2f8b122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01dd03fa9e2e514e99964ec3d70330c5f908557cc9c07d368ba826fe30a5d9be"
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
