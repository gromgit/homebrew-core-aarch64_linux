require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.1.4.tgz"
  sha256 "2ded10e2bd4858705e317e95814a1a9ab3758891133e1a3c2d24215108100831"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c7ae5153e00e707d02e6b75ff5e67caca47b586a9e3b43e4af6348a6c342e52d" => :catalina
    sha256 "3897aba4289aea3245066478d74120dd3727fc8a08c6b2a5244189ec9fabb72c" => :mojave
    sha256 "05c24fa1f9718fff197b8ffc722cd22a041ca755b26f1945b24ca08759ba4770" => :high_sierra
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
