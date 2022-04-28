require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.4.tgz"
  sha256 "f8d472d52e0d11b269c97a29880e87c9bdbc7a2b183b25e97fe7341bf30891a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4ed8f8b71fb3afdffe58b75a14e5196bdb313be4139fdf5d908dd6074999e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa4ed8f8b71fb3afdffe58b75a14e5196bdb313be4139fdf5d908dd6074999e4"
    sha256 cellar: :any_skip_relocation, monterey:       "f68fd746ca72ea5af95008259a365b6ceb88b82708058a84331a93aac7c6eb38"
    sha256 cellar: :any_skip_relocation, big_sur:        "f68fd746ca72ea5af95008259a365b6ceb88b82708058a84331a93aac7c6eb38"
    sha256 cellar: :any_skip_relocation, catalina:       "f68fd746ca72ea5af95008259a365b6ceb88b82708058a84331a93aac7c6eb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4ed8f8b71fb3afdffe58b75a14e5196bdb313be4139fdf5d908dd6074999e4"
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
