require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.44.tgz"
  sha256 "534c2401dd69ccfac04453ab3ac441bf04028c7586e7e7715f77a270abae573a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67d6b7363311830d9d2f979ad5a67e76021a016f89d9577d9be4c0e23ee36bf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67d6b7363311830d9d2f979ad5a67e76021a016f89d9577d9be4c0e23ee36bf0"
    sha256 cellar: :any_skip_relocation, monterey:       "6ac306086a2ed8c84a78678e2f5ddda992814ee8eb7300bf84c496d66ebc54cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ac306086a2ed8c84a78678e2f5ddda992814ee8eb7300bf84c496d66ebc54cc"
    sha256 cellar: :any_skip_relocation, catalina:       "6ac306086a2ed8c84a78678e2f5ddda992814ee8eb7300bf84c496d66ebc54cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67d6b7363311830d9d2f979ad5a67e76021a016f89d9577d9be4c0e23ee36bf0"
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
