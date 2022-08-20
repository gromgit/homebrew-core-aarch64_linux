require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.55.tgz"
  sha256 "b9fa40c4f26df0344d46d0f5047193033053f5961a1f1ed86331565ac8c6b61d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97a0ce6d3fb078e38128125d61ffd22d2549ba38da1c32fde84447f43a0a1cd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97a0ce6d3fb078e38128125d61ffd22d2549ba38da1c32fde84447f43a0a1cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "e373feabbde39d4fd592627e45537163bba76fd2af7c9c8c9696a0234766b0d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e373feabbde39d4fd592627e45537163bba76fd2af7c9c8c9696a0234766b0d0"
    sha256 cellar: :any_skip_relocation, catalina:       "e373feabbde39d4fd592627e45537163bba76fd2af7c9c8c9696a0234766b0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97a0ce6d3fb078e38128125d61ffd22d2549ba38da1c32fde84447f43a0a1cd6"
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
