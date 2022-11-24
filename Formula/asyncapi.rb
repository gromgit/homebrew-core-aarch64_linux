require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.26.2.tgz"
  sha256 "d857e9a02a60ec1ad43c37d47442c9db29f9ccdbb01d2b16d7c2546518deac08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2cee76f548f764c911fe36b8a4ef84cb7d5ab946ab2f3021b9416f970f210c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2cee76f548f764c911fe36b8a4ef84cb7d5ab946ab2f3021b9416f970f210c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2cee76f548f764c911fe36b8a4ef84cb7d5ab946ab2f3021b9416f970f210c8"
    sha256 cellar: :any_skip_relocation, monterey:       "1239cdbd7adffdc00fb3da33851cc148eb2ce127f1af650dba3d3007811c1835"
    sha256 cellar: :any_skip_relocation, big_sur:        "1239cdbd7adffdc00fb3da33851cc148eb2ce127f1af650dba3d3007811c1835"
    sha256 cellar: :any_skip_relocation, catalina:       "1239cdbd7adffdc00fb3da33851cc148eb2ce127f1af650dba3d3007811c1835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f871ce4a14fcb1c51bc52f7da5568eee95ff06d89bbdf45eb27ef370828b12"
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
