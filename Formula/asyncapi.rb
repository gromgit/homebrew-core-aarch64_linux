require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.7.tgz"
  sha256 "9ade89f84eeca81380f5b54d8f9c7e03f1e06a9eab404ce6919778e109abfb2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195e69298a6f4aa7a358cca61fb5a9dd2c5ff2f0dd96708556002991992a1571"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "195e69298a6f4aa7a358cca61fb5a9dd2c5ff2f0dd96708556002991992a1571"
    sha256 cellar: :any_skip_relocation, monterey:       "78443ee29f0934eaf35ddb5dc70bec4d149d16e62faecbf68bc86c1717a6c63c"
    sha256 cellar: :any_skip_relocation, big_sur:        "78443ee29f0934eaf35ddb5dc70bec4d149d16e62faecbf68bc86c1717a6c63c"
    sha256 cellar: :any_skip_relocation, catalina:       "78443ee29f0934eaf35ddb5dc70bec4d149d16e62faecbf68bc86c1717a6c63c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44167f9b83cf6a1771458e017a8adbae64432fb10bba243830673e3482b44d5a"
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
