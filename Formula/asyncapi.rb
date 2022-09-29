require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.25.0.tgz"
  sha256 "793d83a7940c1e94f100d777822e2a7561eb39cd55e2dc7a31367ced4aa54591"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3f02c314eeb3c1cfd09e27fe1d9bb17f9f05c1566decbb249976c0b46ae8b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3f02c314eeb3c1cfd09e27fe1d9bb17f9f05c1566decbb249976c0b46ae8b9f"
    sha256 cellar: :any_skip_relocation, monterey:       "0791fd7bea5a55f977be8c67afea9bba5134433a5b38029ac9ec785f643d4b20"
    sha256 cellar: :any_skip_relocation, big_sur:        "0791fd7bea5a55f977be8c67afea9bba5134433a5b38029ac9ec785f643d4b20"
    sha256 cellar: :any_skip_relocation, catalina:       "0791fd7bea5a55f977be8c67afea9bba5134433a5b38029ac9ec785f643d4b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d8b7b1688624be3cf01b10ba1be4ce92b76e6e7e58acbfed6b0173cc3da3fa"
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
