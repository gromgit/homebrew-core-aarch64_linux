require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.24.1.tgz"
  sha256 "20e79acaa701b96eb441b61428bfbdcc52161e06403493e323e021bdc13086ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e4355260e2aced0dcb0e14cf89b5e6d93e3930d19a4f85bbeb9264672547fbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e4355260e2aced0dcb0e14cf89b5e6d93e3930d19a4f85bbeb9264672547fbd"
    sha256 cellar: :any_skip_relocation, monterey:       "478f2e5032a032dffd1b12a4d1f1609cbe3566ae5631de4bb448be8805f979dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "478f2e5032a032dffd1b12a4d1f1609cbe3566ae5631de4bb448be8805f979dc"
    sha256 cellar: :any_skip_relocation, catalina:       "478f2e5032a032dffd1b12a4d1f1609cbe3566ae5631de4bb448be8805f979dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5188f1fade02ad6eb3f9ea22a090a122b532670a6f1bee8570fd7fbe15c30b2"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
