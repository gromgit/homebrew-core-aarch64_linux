require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.2.tgz"
  sha256 "719a6000a583993974a08eadb8d613734799a49690e45f3d221b8991f488349e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b773ae916aaefc2d32732360aa0f3584abea37b89354ba9d2b331b5a8e669311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b773ae916aaefc2d32732360aa0f3584abea37b89354ba9d2b331b5a8e669311"
    sha256 cellar: :any_skip_relocation, monterey:       "0be7be6d4f12b24bb84f888cf0536443d68969db7695924cf274137061df9696"
    sha256 cellar: :any_skip_relocation, big_sur:        "0be7be6d4f12b24bb84f888cf0536443d68969db7695924cf274137061df9696"
    sha256 cellar: :any_skip_relocation, catalina:       "0be7be6d4f12b24bb84f888cf0536443d68969db7695924cf274137061df9696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b773ae916aaefc2d32732360aa0f3584abea37b89354ba9d2b331b5a8e669311"
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
