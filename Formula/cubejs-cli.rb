require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.10.tgz"
  sha256 "1645315e1597cb6ce24d202471a6db374ea59187b9731f2cb2a500b32cfcbd03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69e93790b406b44e9b8e093d981e45caa3f12f598d6a2e65848035dc0d190315"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69e93790b406b44e9b8e093d981e45caa3f12f598d6a2e65848035dc0d190315"
    sha256 cellar: :any_skip_relocation, monterey:       "e3de57ff723e3254e7a8f885fd59fe6f99fe009e45c874baadfbd1c4ef00f8e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3de57ff723e3254e7a8f885fd59fe6f99fe009e45c874baadfbd1c4ef00f8e7"
    sha256 cellar: :any_skip_relocation, catalina:       "e3de57ff723e3254e7a8f885fd59fe6f99fe009e45c874baadfbd1c4ef00f8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69e93790b406b44e9b8e093d981e45caa3f12f598d6a2e65848035dc0d190315"
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
