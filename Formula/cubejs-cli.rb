require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.42.tgz"
  sha256 "efcd744d77f22004aee99c5f6ee0a37c98e2ef5d2704454606e709e008b84b9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8910227328b671a453e300c01eb3b90866d7001aaa0c6da55fc0d75a872d4448"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8910227328b671a453e300c01eb3b90866d7001aaa0c6da55fc0d75a872d4448"
    sha256 cellar: :any_skip_relocation, monterey:       "0f50dc22fca892197fbb524bc7a9615a529a4c7f0714ed723c90d6c4c3c12e15"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f50dc22fca892197fbb524bc7a9615a529a4c7f0714ed723c90d6c4c3c12e15"
    sha256 cellar: :any_skip_relocation, catalina:       "0f50dc22fca892197fbb524bc7a9615a529a4c7f0714ed723c90d6c4c3c12e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8910227328b671a453e300c01eb3b90866d7001aaa0c6da55fc0d75a872d4448"
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
