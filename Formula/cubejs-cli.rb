require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.55.tgz"
  sha256 "d21535283272cf6e48be984cbd8a2e9928d42975c4027dddbb07c0214d19e7fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35572b3eb4783a1e74ec4c262d85fb84eb1f3670c9df424db8dff4cd1aa9b0aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35572b3eb4783a1e74ec4c262d85fb84eb1f3670c9df424db8dff4cd1aa9b0aa"
    sha256 cellar: :any_skip_relocation, monterey:       "cb4e839f3aba0c1d3533591f62af417aea0ddb9c2bdb14594038b748e45f06bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb4e839f3aba0c1d3533591f62af417aea0ddb9c2bdb14594038b748e45f06bb"
    sha256 cellar: :any_skip_relocation, catalina:       "cb4e839f3aba0c1d3533591f62af417aea0ddb9c2bdb14594038b748e45f06bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35572b3eb4783a1e74ec4c262d85fb84eb1f3670c9df424db8dff4cd1aa9b0aa"
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
