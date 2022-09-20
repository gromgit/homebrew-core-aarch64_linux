require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.74.tgz"
  sha256 "45725d3f5509d68e24907f24073e480703dab574f865744662200539d8dd86da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbc251813ec287eda6034e93e9f5cc125f5e6d9dcb7a24fa20c97800ab7383d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebbc251813ec287eda6034e93e9f5cc125f5e6d9dcb7a24fa20c97800ab7383d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4b8621eeb6049afef1523823d92b85749d85e0c01c8d59268832f8c94f4d18"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4b8621eeb6049afef1523823d92b85749d85e0c01c8d59268832f8c94f4d18"
    sha256 cellar: :any_skip_relocation, catalina:       "4d4b8621eeb6049afef1523823d92b85749d85e0c01c8d59268832f8c94f4d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebbc251813ec287eda6034e93e9f5cc125f5e6d9dcb7a24fa20c97800ab7383d"
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
