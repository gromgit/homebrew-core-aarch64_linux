require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.8.tgz"
  sha256 "b01298806d494334b164011092d744dd8fcc4d8efabd43dce0f4178877aa1abc"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "857401e1faf354eeea4ee8516b1aae4579d7c529bffea27079f07d705df01c44" => :catalina
    sha256 "6379a2382a3f34e5aca9712e8bf9986c03981dec82278155d8c5693a8b0d9c49" => :mojave
    sha256 "c445d6c4ce94c64d3d39708d9aa8eaf8a09f684d254f896b870c7271d4fb7a8d" => :high_sierra
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
