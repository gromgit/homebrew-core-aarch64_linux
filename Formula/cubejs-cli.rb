require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.5.tgz"
  sha256 "1aa7e732297bb9aa08a168f24b5d8988a0627eef74d760e5a304d3803844562a"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fe27b3b649d4dd7d2b91ffbcb67e6d7cf59f212c0c222f485d7b47343fbf5c09" => :catalina
    sha256 "14b9611316f812f953e2ff3366d503a235a006f5f676e5d3a218f077fb13b1f0" => :mojave
    sha256 "d48c2295e137c55a2e4375173260ba1491519fbec401e1302e5d7ce7f009d441" => :high_sierra
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
