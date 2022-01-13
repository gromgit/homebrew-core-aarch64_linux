require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.1.3.tgz"
  sha256 "4f7e3589f732f5c40d030d3e44c58e54e7f139bff6061ddef68600a48ac25b1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c25043f82f4ab867d08769edba6efd0825d3ea7d081a7b44cd272e6a68b8d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7c25043f82f4ab867d08769edba6efd0825d3ea7d081a7b44cd272e6a68b8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "7a35059aa05e185b945d5c394f6eb74b6eda7bbff2b98119ff2ed4b9e3f1d40f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a35059aa05e185b945d5c394f6eb74b6eda7bbff2b98119ff2ed4b9e3f1d40f"
    sha256 cellar: :any_skip_relocation, catalina:       "7a35059aa05e185b945d5c394f6eb74b6eda7bbff2b98119ff2ed4b9e3f1d40f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7c25043f82f4ab867d08769edba6efd0825d3ea7d081a7b44cd272e6a68b8d8"
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
