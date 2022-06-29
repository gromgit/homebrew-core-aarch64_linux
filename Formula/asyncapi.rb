require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.20.1.tgz"
  sha256 "d113b063016504d018b9d0d0affea8c0a6f1cb012ae6403396c2d2ecd3bcb28d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9ac14adb9a7f5d94f0b2c80862de3b1e6f590b1e1d82a3160ae4dc3e6fa65d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf9ac14adb9a7f5d94f0b2c80862de3b1e6f590b1e1d82a3160ae4dc3e6fa65d"
    sha256 cellar: :any_skip_relocation, monterey:       "5fe998cc599ac55d990fa1515da4f93daa93636c4a656d38badddf1d8c8d7ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fe998cc599ac55d990fa1515da4f93daa93636c4a656d38badddf1d8c8d7ba0"
    sha256 cellar: :any_skip_relocation, catalina:       "5fe998cc599ac55d990fa1515da4f93daa93636c4a656d38badddf1d8c8d7ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc3e62205720148e0cd173844960912060b2e63767b6706b5344665416c6d14"
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
