require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.48.tgz"
  sha256 "fcdb11b0aba0a20fb3979f7207acc0c6825980777020e35955641ab8c329be78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86821c1d7be6e6c8c9b3a3685e5f772bbd008439c9a868ecf1a419c6b8aac3ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86821c1d7be6e6c8c9b3a3685e5f772bbd008439c9a868ecf1a419c6b8aac3ad"
    sha256 cellar: :any_skip_relocation, monterey:       "dcfd7210aae3cd94c2b8655df90cad6387e412c375c4351c468ad405f998c854"
    sha256 cellar: :any_skip_relocation, big_sur:        "dcfd7210aae3cd94c2b8655df90cad6387e412c375c4351c468ad405f998c854"
    sha256 cellar: :any_skip_relocation, catalina:       "dcfd7210aae3cd94c2b8655df90cad6387e412c375c4351c468ad405f998c854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86821c1d7be6e6c8c9b3a3685e5f772bbd008439c9a868ecf1a419c6b8aac3ad"
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
