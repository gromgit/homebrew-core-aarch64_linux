require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.0.tgz"
  sha256 "9eeb20c9a5fd8c29c089a704f60a996f34d7eb6397c5b00b604b19fd83e5e9d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6425598118b2b0269127b60fbbe23936650500d90ab583a2fcfdde9252b7599"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6425598118b2b0269127b60fbbe23936650500d90ab583a2fcfdde9252b7599"
    sha256 cellar: :any_skip_relocation, monterey:       "9b2c7bca18d28adc85f7422c87e7879aec937b92d672f7b4b4ce67f182766a14"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b2c7bca18d28adc85f7422c87e7879aec937b92d672f7b4b4ce67f182766a14"
    sha256 cellar: :any_skip_relocation, catalina:       "9b2c7bca18d28adc85f7422c87e7879aec937b92d672f7b4b4ce67f182766a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ff04040a28148ef50903bcbc170adca12423c599b94745b4ce5e6aea39e3544"
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
