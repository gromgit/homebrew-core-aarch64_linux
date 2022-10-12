require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.6.tgz"
  sha256 "87568c5169f9ca913de29d9c699286c27cf4402fb2c4224ad6480f5c92093895"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d139fdca6384b528a6d046b5aeaa9649019ec2339b1c9aeb0294d00ab0b0c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d139fdca6384b528a6d046b5aeaa9649019ec2339b1c9aeb0294d00ab0b0c73"
    sha256 cellar: :any_skip_relocation, monterey:       "23689afd98d8e6a22f4e56f3a2d89482083140e99e605be2081cffa44bffbfb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "23689afd98d8e6a22f4e56f3a2d89482083140e99e605be2081cffa44bffbfb7"
    sha256 cellar: :any_skip_relocation, catalina:       "23689afd98d8e6a22f4e56f3a2d89482083140e99e605be2081cffa44bffbfb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d139fdca6384b528a6d046b5aeaa9649019ec2339b1c9aeb0294d00ab0b0c73"
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
