require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.46.tgz"
  sha256 "e49672e4159132f3eae6a103b299e478fef0b6ce61866b02b8fd7647d8a1745c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ccf3ea0429b85a41d283d62c2e6f19ae2401a36f7527b6ca0faea7dad6a7100"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ccf3ea0429b85a41d283d62c2e6f19ae2401a36f7527b6ca0faea7dad6a7100"
    sha256 cellar: :any_skip_relocation, monterey:       "280daffa24b131da59272f98993d936e9f0c0d7c290c2b231840e0fb768bbe8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "280daffa24b131da59272f98993d936e9f0c0d7c290c2b231840e0fb768bbe8e"
    sha256 cellar: :any_skip_relocation, catalina:       "280daffa24b131da59272f98993d936e9f0c0d7c290c2b231840e0fb768bbe8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ccf3ea0429b85a41d283d62c2e6f19ae2401a36f7527b6ca0faea7dad6a7100"
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
