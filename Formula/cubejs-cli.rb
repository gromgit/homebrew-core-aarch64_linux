require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.56.tgz"
  sha256 "8a09a292c3cdff055000e057e8eb7bd3bd75d06d57ca151029fc40a70d306b08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1d65956053eb9cf26562f5af6535ac9cc80ed60396a5262a8b6b5079b04203b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1d65956053eb9cf26562f5af6535ac9cc80ed60396a5262a8b6b5079b04203b"
    sha256 cellar: :any_skip_relocation, monterey:       "d23edb2cac0fbc38c81aa0110c90c4ea0f3d524aaf248bb1c78b75b376735097"
    sha256 cellar: :any_skip_relocation, big_sur:        "d23edb2cac0fbc38c81aa0110c90c4ea0f3d524aaf248bb1c78b75b376735097"
    sha256 cellar: :any_skip_relocation, catalina:       "d23edb2cac0fbc38c81aa0110c90c4ea0f3d524aaf248bb1c78b75b376735097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1d65956053eb9cf26562f5af6535ac9cc80ed60396a5262a8b6b5079b04203b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
