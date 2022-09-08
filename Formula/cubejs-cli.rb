require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.65.tgz"
  sha256 "14e7042bbd849d748e69ae82a2e329d519e7983242c100f638b9566e92d3f700"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8acebe2b4ac5031d43147a97dda4791dac7b1b595beddf2200bd482d66b61e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8acebe2b4ac5031d43147a97dda4791dac7b1b595beddf2200bd482d66b61e6"
    sha256 cellar: :any_skip_relocation, monterey:       "1193646a39b88f477477fef4d0b401044aa1e37de80504dd4395215eb5e313f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1193646a39b88f477477fef4d0b401044aa1e37de80504dd4395215eb5e313f1"
    sha256 cellar: :any_skip_relocation, catalina:       "1193646a39b88f477477fef4d0b401044aa1e37de80504dd4395215eb5e313f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8acebe2b4ac5031d43147a97dda4791dac7b1b595beddf2200bd482d66b61e6"
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
