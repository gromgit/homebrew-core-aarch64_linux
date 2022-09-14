require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.69.tgz"
  sha256 "b489282896de727b847f883ec3970d38891af2e98f4bc4281f4aab277380d2cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d6907397f0ea6b5eb490e117c9f9d73ee9415ee7d175e783f2a7ae2f62151a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d6907397f0ea6b5eb490e117c9f9d73ee9415ee7d175e783f2a7ae2f62151a9"
    sha256 cellar: :any_skip_relocation, monterey:       "6a3690a0b904acabec3b43ac58f732e14c0301059a0ca4b924881fa9043869a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a3690a0b904acabec3b43ac58f732e14c0301059a0ca4b924881fa9043869a5"
    sha256 cellar: :any_skip_relocation, catalina:       "6a3690a0b904acabec3b43ac58f732e14c0301059a0ca4b924881fa9043869a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d6907397f0ea6b5eb490e117c9f9d73ee9415ee7d175e783f2a7ae2f62151a9"
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
