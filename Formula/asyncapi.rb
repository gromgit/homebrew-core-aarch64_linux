require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.22.7.tgz"
  sha256 "0f183b18fb273bd331070d7c75117b21ba74c3672c3d9f4fde044560bbe95ab8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9da1dfb4b45eb1980c47b1af343e6eb869e3dc83200405ae753e492d3038bb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9da1dfb4b45eb1980c47b1af343e6eb869e3dc83200405ae753e492d3038bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4f9c7c7202d8758a8184f42f477f77ac5d2d1070da143bd4234f5da27d0538"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d4f9c7c7202d8758a8184f42f477f77ac5d2d1070da143bd4234f5da27d0538"
    sha256 cellar: :any_skip_relocation, catalina:       "0d4f9c7c7202d8758a8184f42f477f77ac5d2d1070da143bd4234f5da27d0538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7eff4293752fbc7445cd5bc6ff776e2cb06bc0af1c01d6fbebd6969108a5182"
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
