require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.11.tgz"
  sha256 "a1968618854d7e261d7698f1dda4214d3b970285ef4e9c1161a9310dcb05eef4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23f572adb48ed93ee02a086f7c135a96f03f9bf9cec92c50bf83586529d2f9dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23f572adb48ed93ee02a086f7c135a96f03f9bf9cec92c50bf83586529d2f9dc"
    sha256 cellar: :any_skip_relocation, monterey:       "69fa735007fa84866e6a6c7d944982d6778154b32b43eb5376be9429a011b77e"
    sha256 cellar: :any_skip_relocation, big_sur:        "69fa735007fa84866e6a6c7d944982d6778154b32b43eb5376be9429a011b77e"
    sha256 cellar: :any_skip_relocation, catalina:       "69fa735007fa84866e6a6c7d944982d6778154b32b43eb5376be9429a011b77e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23f572adb48ed93ee02a086f7c135a96f03f9bf9cec92c50bf83586529d2f9dc"
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
