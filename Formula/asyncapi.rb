require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.23.1.tgz"
  sha256 "4e4d856ea76a306e470f4132520898149753aa9cf2742d1c923e5e7147ebc2a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa19b9a73e4d58ac5bd31842fab9132bc7f77ee9e51fe09c12683cf5082357a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa19b9a73e4d58ac5bd31842fab9132bc7f77ee9e51fe09c12683cf5082357a6"
    sha256 cellar: :any_skip_relocation, monterey:       "91f80bd39c731ee2f971021cc9e2552b913f4a0f06fbea752cbd76dea9915db5"
    sha256 cellar: :any_skip_relocation, big_sur:        "91f80bd39c731ee2f971021cc9e2552b913f4a0f06fbea752cbd76dea9915db5"
    sha256 cellar: :any_skip_relocation, catalina:       "91f80bd39c731ee2f971021cc9e2552b913f4a0f06fbea752cbd76dea9915db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f2b07b1d23c796e101992876d1e7ada7a954da34ee2d2bc34ca2b42ca2b45b"
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
