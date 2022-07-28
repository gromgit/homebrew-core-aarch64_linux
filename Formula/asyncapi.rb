require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.22.1.tgz"
  sha256 "8a750852b6d6ac335c4c332201a85be0d76ed1ad160e74db569e714ed2a51191"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "830ec101ff850b43a8afa42476c3ef6859c713c9404ad000e700a90e05217fcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "830ec101ff850b43a8afa42476c3ef6859c713c9404ad000e700a90e05217fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "e437075a492dd3c430d912de19a6cc37c36e101752ab3a107e9d3639d3520fd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e437075a492dd3c430d912de19a6cc37c36e101752ab3a107e9d3639d3520fd8"
    sha256 cellar: :any_skip_relocation, catalina:       "e437075a492dd3c430d912de19a6cc37c36e101752ab3a107e9d3639d3520fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73cf0f8cc128bb6df0064b52b558bd933d09be4d8551ae7398cb307246bd0936"
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
