require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.4.tgz"
  sha256 "f8d472d52e0d11b269c97a29880e87c9bdbc7a2b183b25e97fe7341bf30891a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1abd6031ed795e621ddba2a6ebaa9cfc98239fe08f1308936ee7877f3539bb6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1abd6031ed795e621ddba2a6ebaa9cfc98239fe08f1308936ee7877f3539bb6e"
    sha256 cellar: :any_skip_relocation, monterey:       "2f991b6d606880f0b8c4bbfb76f805c6d485436f2b0d34b89b1b8b6a06a49944"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f991b6d606880f0b8c4bbfb76f805c6d485436f2b0d34b89b1b8b6a06a49944"
    sha256 cellar: :any_skip_relocation, catalina:       "2f991b6d606880f0b8c4bbfb76f805c6d485436f2b0d34b89b1b8b6a06a49944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1abd6031ed795e621ddba2a6ebaa9cfc98239fe08f1308936ee7877f3539bb6e"
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
