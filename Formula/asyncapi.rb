require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.5.tgz"
  sha256 "06665bcdb53cd030182964602fae0f2c90dc877df8d4150555a225871b1bc833"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eea8c414a6bb5247c51330b825085088b9bba5ee13acd508be3101475a3902f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4eea8c414a6bb5247c51330b825085088b9bba5ee13acd508be3101475a3902f"
    sha256 cellar: :any_skip_relocation, monterey:       "1830c98055f3e935657b2ef0996ee77f4e4eb65d4fe5d5805b85c22405c9341f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1830c98055f3e935657b2ef0996ee77f4e4eb65d4fe5d5805b85c22405c9341f"
    sha256 cellar: :any_skip_relocation, catalina:       "1830c98055f3e935657b2ef0996ee77f4e4eb65d4fe5d5805b85c22405c9341f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16512996bc32c558c412742899dfbf2d27af15035c6b60b171b5b2cf9c88490c"
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
