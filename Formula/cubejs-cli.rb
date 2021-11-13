require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.55.tgz"
  sha256 "bf341d3e211fa1f08e73a57772462d57319627e2e94d40d8156ed5b6cd14f6b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "459a4a3257e813d2184640bc52556effc3a0966c176d7eee881302718570f445"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "459a4a3257e813d2184640bc52556effc3a0966c176d7eee881302718570f445"
    sha256 cellar: :any_skip_relocation, monterey:       "e61191c90935767b55637dbd9745b06107969aee407c428b38c34c9984a29339"
    sha256 cellar: :any_skip_relocation, big_sur:        "e61191c90935767b55637dbd9745b06107969aee407c428b38c34c9984a29339"
    sha256 cellar: :any_skip_relocation, catalina:       "e61191c90935767b55637dbd9745b06107969aee407c428b38c34c9984a29339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "459a4a3257e813d2184640bc52556effc3a0966c176d7eee881302718570f445"
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
