require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.74.tgz"
  sha256 "45725d3f5509d68e24907f24073e480703dab574f865744662200539d8dd86da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72d28e3c6bb3d886bf7aa3136735b291c9b82e0307100e42c870845518016b2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72d28e3c6bb3d886bf7aa3136735b291c9b82e0307100e42c870845518016b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "dbed013e4a259e1e8a8b20ec5d421e89e11a2fc0ab7ce4e269ce312a4a1e1983"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbed013e4a259e1e8a8b20ec5d421e89e11a2fc0ab7ce4e269ce312a4a1e1983"
    sha256 cellar: :any_skip_relocation, catalina:       "dbed013e4a259e1e8a8b20ec5d421e89e11a2fc0ab7ce4e269ce312a4a1e1983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d28e3c6bb3d886bf7aa3136735b291c9b82e0307100e42c870845518016b2a"
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
