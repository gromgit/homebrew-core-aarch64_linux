require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.12.tgz"
  sha256 "5d0ec60d831ea557eab7eede07b0eabe7bae6e8df47fd277039b1886e590cb94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62b690d4d8f51ea3c209ebb40e5abec9c573184972a6e0a18f06931ea433a7d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f7a2a1a112bc2efa1119f103a9a546707976821913932f8f6fd9b17ba7f5232"
    sha256 cellar: :any_skip_relocation, catalina:      "5aa971a7a6e75e2ebfcb685e39799ee64a502995dead35fd0e1d6e0f67f460bb"
    sha256 cellar: :any_skip_relocation, mojave:        "dbf46ca6d622c1b1b4ca52922199956ef567fa56b2e54962221ef92925239d28"
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
