require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.49.tgz"
  sha256 "303da412e7f9b432385d93c1bafce88fc7035acd28c571fcff6e8016f35f344c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbe8c84b475a185071b46fa74b37172d209c0acb4591e4660b52326a7412356b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbe8c84b475a185071b46fa74b37172d209c0acb4591e4660b52326a7412356b"
    sha256 cellar: :any_skip_relocation, monterey:       "83fc2452d50fa0605998a0665b8a934cdbfad28647ef4c2d4a78d9257b4729c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "83fc2452d50fa0605998a0665b8a934cdbfad28647ef4c2d4a78d9257b4729c5"
    sha256 cellar: :any_skip_relocation, catalina:       "83fc2452d50fa0605998a0665b8a934cdbfad28647ef4c2d4a78d9257b4729c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe8c84b475a185071b46fa74b37172d209c0acb4591e4660b52326a7412356b"
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
