require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.10.tgz"
  sha256 "87bc84e18d093f062f7d194a4e279ffd3d91ea1dfebb73d8eb79b7259b77e4d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "276a78cf50d081e9e02c9df0159df9191b89e3e26dffea2a05b36af89f4c877e"
    sha256 cellar: :any_skip_relocation, big_sur:       "6897d5cb59d6e26631d8120e303e924d456beb827088a3656c0a5dc403b8ad90"
    sha256 cellar: :any_skip_relocation, catalina:      "6897d5cb59d6e26631d8120e303e924d456beb827088a3656c0a5dc403b8ad90"
    sha256 cellar: :any_skip_relocation, mojave:        "6897d5cb59d6e26631d8120e303e924d456beb827088a3656c0a5dc403b8ad90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "276a78cf50d081e9e02c9df0159df9191b89e3e26dffea2a05b36af89f4c877e"
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
