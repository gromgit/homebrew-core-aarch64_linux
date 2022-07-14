require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.8.tgz"
  sha256 "cc20ad80a7c0fee15516b54a491688aeb74b3d9c8697f1f2fd15228a8c962657"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4538f55f29fb496ad8779aad09e885d6f1161f9cc11c160f303930a4a0fef03c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4538f55f29fb496ad8779aad09e885d6f1161f9cc11c160f303930a4a0fef03c"
    sha256 cellar: :any_skip_relocation, monterey:       "23fd8c2c8916ce67b90604e38fe133fb342f43381eefb3f7fc792d7a5c35391d"
    sha256 cellar: :any_skip_relocation, big_sur:        "23fd8c2c8916ce67b90604e38fe133fb342f43381eefb3f7fc792d7a5c35391d"
    sha256 cellar: :any_skip_relocation, catalina:       "23fd8c2c8916ce67b90604e38fe133fb342f43381eefb3f7fc792d7a5c35391d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1566d6b7d7db5784daed62e740be78b189ad51b7826a13713bbd4b1790960faa"
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
