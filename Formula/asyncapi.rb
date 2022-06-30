require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.1.tgz"
  sha256 "1563e7863c5631801baad98ffc46efef3758db3efb74326cd787981d14d300f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f9ed68bf64f4eab71b342214ca264866fa15922e0bfcf256f7d70d82f8a64ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f9ed68bf64f4eab71b342214ca264866fa15922e0bfcf256f7d70d82f8a64ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4f75afa1028d3431cea490d6127d611fc47b651820ffff7ff7d268482eaf7aa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd7fa6b5964ffd07a55df9c86943560ddf562c264d552cdf36d6aa90a3d3f3b1"
    sha256 cellar: :any_skip_relocation, catalina:       "cd7fa6b5964ffd07a55df9c86943560ddf562c264d552cdf36d6aa90a3d3f3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04882bc1af9653449f4aa780d0e01ac7d977c9517222bc82913649c669079c97"
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
