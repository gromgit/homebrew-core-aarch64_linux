require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.0.tgz"
  sha256 "e45214184819292721939dc15211e9e7342e9060ca839d771aa4a0fda3eb120e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75eba3f6dc822d9082c8199ec4e579a99d48050082c6d80988628ea55c84d5d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75eba3f6dc822d9082c8199ec4e579a99d48050082c6d80988628ea55c84d5d5"
    sha256 cellar: :any_skip_relocation, monterey:       "0289bbe8a8a8e2ab4398d18927a971425792c40b658894eeaf2c2b63d70cca05"
    sha256 cellar: :any_skip_relocation, big_sur:        "0289bbe8a8a8e2ab4398d18927a971425792c40b658894eeaf2c2b63d70cca05"
    sha256 cellar: :any_skip_relocation, catalina:       "0289bbe8a8a8e2ab4398d18927a971425792c40b658894eeaf2c2b63d70cca05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75eba3f6dc822d9082c8199ec4e579a99d48050082c6d80988628ea55c84d5d5"
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
