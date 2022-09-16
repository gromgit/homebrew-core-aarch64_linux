require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.71.tgz"
  sha256 "95eda5940f4040abb70bcb67cde7e64389ca06873812278a4a669f6b0f7b6208"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "830c2834d93920da46a896690dc8aed9aae91cadb58c5b897e7447625b07e2d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "830c2834d93920da46a896690dc8aed9aae91cadb58c5b897e7447625b07e2d5"
    sha256 cellar: :any_skip_relocation, monterey:       "a5a1207b8dbcbc4e804ab36a16a3aa70c364eb09322b698cd750120983f0bcf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5a1207b8dbcbc4e804ab36a16a3aa70c364eb09322b698cd750120983f0bcf6"
    sha256 cellar: :any_skip_relocation, catalina:       "a5a1207b8dbcbc4e804ab36a16a3aa70c364eb09322b698cd750120983f0bcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "830c2834d93920da46a896690dc8aed9aae91cadb58c5b897e7447625b07e2d5"
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
