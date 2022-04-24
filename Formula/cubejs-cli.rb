require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.52.tgz"
  sha256 "925db9e5592caac1961cb37c7b69afbaecce2987270a146b5a674982698a8cfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7059462cfc85f363577aad01088b7b930a429518a59064c47d4951c6c852947"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7059462cfc85f363577aad01088b7b930a429518a59064c47d4951c6c852947"
    sha256 cellar: :any_skip_relocation, monterey:       "df480962a7608710f7799ae3c7c23a4a64b51eb3c589d9b103763136852a576e"
    sha256 cellar: :any_skip_relocation, big_sur:        "df480962a7608710f7799ae3c7c23a4a64b51eb3c589d9b103763136852a576e"
    sha256 cellar: :any_skip_relocation, catalina:       "df480962a7608710f7799ae3c7c23a4a64b51eb3c589d9b103763136852a576e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7059462cfc85f363577aad01088b7b930a429518a59064c47d4951c6c852947"
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
