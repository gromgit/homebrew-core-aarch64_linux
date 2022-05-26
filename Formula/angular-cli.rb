require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.7.tgz"
  sha256 "b8641f8f270861023a0c37cc3f445969d27580687a1fbd8ccf822f55a48b8637"
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
