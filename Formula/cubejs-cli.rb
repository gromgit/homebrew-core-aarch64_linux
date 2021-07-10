require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.49.tgz"
  sha256 "414d8f4459e86f843441e13aafe8a0759cce953fe38d90979e5bb432989ac636"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ffd158184b486a9a5a12a2d40324d848d72e6556851db287a4759c5187ce6cc8"
    sha256 cellar: :any_skip_relocation, big_sur:       "a192c3597d34ceab5bf0abc1659a045cf924b49dc8fac780956be84e4f080832"
    sha256 cellar: :any_skip_relocation, catalina:      "a192c3597d34ceab5bf0abc1659a045cf924b49dc8fac780956be84e4f080832"
    sha256 cellar: :any_skip_relocation, mojave:        "a192c3597d34ceab5bf0abc1659a045cf924b49dc8fac780956be84e4f080832"
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
