require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.22.7.tgz"
  sha256 "0f183b18fb273bd331070d7c75117b21ba74c3672c3d9f4fde044560bbe95ab8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ee8d3d4aa7b527de8feb544b5112ae2b3c17f48bb0edd67b9a29235ac5841da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ee8d3d4aa7b527de8feb544b5112ae2b3c17f48bb0edd67b9a29235ac5841da"
    sha256 cellar: :any_skip_relocation, monterey:       "1529e2a52daa23f34056ff6ea4a0cfc03e31eb03f34d7fa3b17930ec2d9b1fdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1529e2a52daa23f34056ff6ea4a0cfc03e31eb03f34d7fa3b17930ec2d9b1fdf"
    sha256 cellar: :any_skip_relocation, catalina:       "1529e2a52daa23f34056ff6ea4a0cfc03e31eb03f34d7fa3b17930ec2d9b1fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a81dc2f0c7794337527afcec29707c70ba7b97163ce26d646e4146814a44dd5"
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
