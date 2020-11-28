require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.2.tgz"
  sha256 "947262321a72f80b4660e7abd80f596bbae5934950cd0b8a05493c56d8a1758d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "34492401413c7de835e84c32977f957267ff80e1bfa21526c2a5ac2e1fd39125" => :big_sur
    sha256 "3deec04e6d4da65bc1647261663411de215e5eb02677e05af850b0cafd39b40b" => :catalina
    sha256 "cc835570c32d705b124d7be10878be197bffc55a1a27c8ea086c1021bd7e3053" => :mojave
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
