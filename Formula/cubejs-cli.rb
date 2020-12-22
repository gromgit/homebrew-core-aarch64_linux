require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.0.tgz"
  sha256 "f6f763efbb013cf9fabdedec9cccb3d61a8d7fa9cfc1c714ad880cfe76e4f21e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b368d5f45e05ef4be1c7bdcdce8c1e0cab564651eea873d9250e9ff5df4e56cc" => :big_sur
    sha256 "b243c67e2877f090b730111751376368e88fbb9c1690108cb3d4beee23938f27" => :catalina
    sha256 "c34f1f56c3e9d7fd6358621d072a205b96c7bece271cbd77e2fceb5c41b3b8d9" => :mojave
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
