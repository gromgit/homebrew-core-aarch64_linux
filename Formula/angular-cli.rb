require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.0.0.tgz"
  sha256 "9d0e5fdce1132ee33183f75e58eac1fb8db4e76518fadfaf620f52a6914ee8ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8674b8b7ee306fabe17073817166ccebbb1a423b11f57bd15bfd2a647e4927b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8674b8b7ee306fabe17073817166ccebbb1a423b11f57bd15bfd2a647e4927b"
    sha256 cellar: :any_skip_relocation, monterey:       "b11163cb8aede9944f908bfc72f9a4a0df3014266d3e2c5056118ebc01c077b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b11163cb8aede9944f908bfc72f9a4a0df3014266d3e2c5056118ebc01c077b9"
    sha256 cellar: :any_skip_relocation, catalina:       "b11163cb8aede9944f908bfc72f9a4a0df3014266d3e2c5056118ebc01c077b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8674b8b7ee306fabe17073817166ccebbb1a423b11f57bd15bfd2a647e4927b"
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
