require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.63.tgz"
  sha256 "8c152e48d459479eee5b8795892d6b3c74a48dac26138adc8f72fd7bbb0b0b1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4150473bab8a2311c3647425f83bb4a9923296a96dc50ef0e20ebb6cf94fc5d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4150473bab8a2311c3647425f83bb4a9923296a96dc50ef0e20ebb6cf94fc5d1"
    sha256 cellar: :any_skip_relocation, monterey:       "5bb8551c3c392c6f59923f64526a3f1c60a737bef3d5fc357e288971ef5e5ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bb8551c3c392c6f59923f64526a3f1c60a737bef3d5fc357e288971ef5e5ddc"
    sha256 cellar: :any_skip_relocation, catalina:       "5bb8551c3c392c6f59923f64526a3f1c60a737bef3d5fc357e288971ef5e5ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4150473bab8a2311c3647425f83bb4a9923296a96dc50ef0e20ebb6cf94fc5d1"
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
