require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.22.2.tgz"
  sha256 "9e69b9cacc4ebdb866e4605d3c221d55ab8a791dae432a1880f2919c45948a98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4787778c6eb5f19243261f0754c2fa445708020780c243424cb9f419b24c3e97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4787778c6eb5f19243261f0754c2fa445708020780c243424cb9f419b24c3e97"
    sha256 cellar: :any_skip_relocation, monterey:       "9e0eddbd65afbd59099f6c5e66a32a6190dd4cdb0b19d4f52d2fd2201e18b810"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e0eddbd65afbd59099f6c5e66a32a6190dd4cdb0b19d4f52d2fd2201e18b810"
    sha256 cellar: :any_skip_relocation, catalina:       "9e0eddbd65afbd59099f6c5e66a32a6190dd4cdb0b19d4f52d2fd2201e18b810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f5f280768a16dcd2c484cea4651777bcf1054f3da5cd3b8bba985c8b7c9091"
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
