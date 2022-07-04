require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.4.tgz"
  sha256 "53de3a9ca865fa19de1fcc28f32e2a694ce8bc20bbae877c8c3fa949969ce472"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c4c2571fb1ec0c78f253c83ba4f20af8398ba76eaea1ee75b2270af02c182f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94c4c2571fb1ec0c78f253c83ba4f20af8398ba76eaea1ee75b2270af02c182f"
    sha256 cellar: :any_skip_relocation, monterey:       "97f8158dd80282d6673578b2179c502af9f85d182aa3af7feb5752c5e02b085a"
    sha256 cellar: :any_skip_relocation, big_sur:        "97f8158dd80282d6673578b2179c502af9f85d182aa3af7feb5752c5e02b085a"
    sha256 cellar: :any_skip_relocation, catalina:       "97f8158dd80282d6673578b2179c502af9f85d182aa3af7feb5752c5e02b085a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a23878219260d93729268af4fbfb03da0a1d51e7b1d6e86e88e74d02dab4ed68"
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
