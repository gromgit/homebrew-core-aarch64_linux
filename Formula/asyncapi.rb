require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.25.3.tgz"
  sha256 "9f4766babfb0f6f2719fa404e9aeeacc7449500ccd7df22d24cd8977a9acb9dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3eb62b37a5160a2c7c24733e5116cdad8bc03526005574678cc41f73e583734"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3eb62b37a5160a2c7c24733e5116cdad8bc03526005574678cc41f73e583734"
    sha256 cellar: :any_skip_relocation, monterey:       "ee630595b9b0b376ddc739646fffa7ee58960899f3565c2f15a77b2dbe8cfc51"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee630595b9b0b376ddc739646fffa7ee58960899f3565c2f15a77b2dbe8cfc51"
    sha256 cellar: :any_skip_relocation, catalina:       "ee630595b9b0b376ddc739646fffa7ee58960899f3565c2f15a77b2dbe8cfc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ea90dc8bff2ca3ff17f268d36d085e56eec4ecec6a0634ea5fa6ee5d0a52f8"
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
