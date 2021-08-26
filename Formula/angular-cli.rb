require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.3.tgz"
  sha256 "c8c8dd109519b83535ce985706fb53145d5d349a76ba00129312a70bb815c434"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "da53d3e9582c272cb88b7e999c8c5a448311fb4ec01730ce360a2024df06dadf"
    sha256 cellar: :any_skip_relocation, big_sur:       "379bbe0febc9730bfcbe08b98cc949f93eae20a6fde64a19125e6e4cad62a6df"
    sha256 cellar: :any_skip_relocation, catalina:      "379bbe0febc9730bfcbe08b98cc949f93eae20a6fde64a19125e6e4cad62a6df"
    sha256 cellar: :any_skip_relocation, mojave:        "379bbe0febc9730bfcbe08b98cc949f93eae20a6fde64a19125e6e4cad62a6df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da53d3e9582c272cb88b7e999c8c5a448311fb4ec01730ce360a2024df06dadf"
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
