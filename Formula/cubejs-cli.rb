require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.7.tgz"
  sha256 "15876faf6ca5048390cb443505cd9830c3ed237a50b96ae5fbd06dbe872276c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "392ef5f7e0bbcdf66a3a893d81afdf026418dfdbc06bb90df0691ab293db4959"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "392ef5f7e0bbcdf66a3a893d81afdf026418dfdbc06bb90df0691ab293db4959"
    sha256 cellar: :any_skip_relocation, monterey:       "d15052974bb5db9cced72e390675620617860d50a7a7aca67fba95c233c8a42e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d15052974bb5db9cced72e390675620617860d50a7a7aca67fba95c233c8a42e"
    sha256 cellar: :any_skip_relocation, catalina:       "d15052974bb5db9cced72e390675620617860d50a7a7aca67fba95c233c8a42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "392ef5f7e0bbcdf66a3a893d81afdf026418dfdbc06bb90df0691ab293db4959"
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
