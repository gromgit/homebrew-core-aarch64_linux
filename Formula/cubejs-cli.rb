require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.6.tgz"
  sha256 "c001c7314fd86fb087da32c412bcf055b2ac30c7d6148ff5b7d28ca3a287f6c3"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "912bf205de2a0d995b1c3fedb71d4bd9e5c620077d029c0a2b31ae05afabe690" => :catalina
    sha256 "6196cf03912377ce47882dbb22a3768d2ec89363fc40061702da62b6161a8341" => :mojave
    sha256 "4595512d9fecbd389acb9bb74327733aab3a535bb8065decbcda12ef1e7c0199" => :high_sierra
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
