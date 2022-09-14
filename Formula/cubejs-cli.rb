require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.69.tgz"
  sha256 "b489282896de727b847f883ec3970d38891af2e98f4bc4281f4aab277380d2cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8333fe09b020150c7ff2d064642e91e8769a27988165686ccd9bb8ea9c8ea8ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8333fe09b020150c7ff2d064642e91e8769a27988165686ccd9bb8ea9c8ea8ff"
    sha256 cellar: :any_skip_relocation, monterey:       "a62d95f4eb1bb56aa035734e3aed44c1e0e0bb7795e410fc45c11f7a7b5bf6f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a62d95f4eb1bb56aa035734e3aed44c1e0e0bb7795e410fc45c11f7a7b5bf6f8"
    sha256 cellar: :any_skip_relocation, catalina:       "a62d95f4eb1bb56aa035734e3aed44c1e0e0bb7795e410fc45c11f7a7b5bf6f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8333fe09b020150c7ff2d064642e91e8769a27988165686ccd9bb8ea9c8ea8ff"
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
