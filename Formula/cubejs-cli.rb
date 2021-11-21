require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.59.tgz"
  sha256 "7a437f0da44babf3e8d14973fae6c43bb87695dd60e2de738044c5805fd0543f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7077dd8ac8f8b6f9aa4bed9640e0d179afe2548bd1834c1a57fe4d00ee530683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7077dd8ac8f8b6f9aa4bed9640e0d179afe2548bd1834c1a57fe4d00ee530683"
    sha256 cellar: :any_skip_relocation, monterey:       "76460a60b6a84110986e6b12bb095173d5acef16173c190f1e49debf2ebdd7a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "76460a60b6a84110986e6b12bb095173d5acef16173c190f1e49debf2ebdd7a3"
    sha256 cellar: :any_skip_relocation, catalina:       "76460a60b6a84110986e6b12bb095173d5acef16173c190f1e49debf2ebdd7a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7077dd8ac8f8b6f9aa4bed9640e0d179afe2548bd1834c1a57fe4d00ee530683"
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
