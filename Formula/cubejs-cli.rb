require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.0.tgz"
  sha256 "62e3b75a8677638e4d27b2c5ccc9aa72402dd3d3fb57a3cc90a37efd593e885a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "627766f766d23dbf944be38e3cd150ffe7b32984a8c675164a1c879c15de07dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "627766f766d23dbf944be38e3cd150ffe7b32984a8c675164a1c879c15de07dc"
    sha256 cellar: :any_skip_relocation, monterey:       "97cd7c6c358d3765f75562722e9c81320d6e9557ef7d7e32dcd1997107df2f79"
    sha256 cellar: :any_skip_relocation, big_sur:        "97cd7c6c358d3765f75562722e9c81320d6e9557ef7d7e32dcd1997107df2f79"
    sha256 cellar: :any_skip_relocation, catalina:       "97cd7c6c358d3765f75562722e9c81320d6e9557ef7d7e32dcd1997107df2f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627766f766d23dbf944be38e3cd150ffe7b32984a8c675164a1c879c15de07dc"
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
