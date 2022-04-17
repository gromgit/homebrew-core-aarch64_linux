require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.48.tgz"
  sha256 "fcdb11b0aba0a20fb3979f7207acc0c6825980777020e35955641ab8c329be78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d94d12a59475fe7cc9ba31e53be997c0e1d50d24099a808e6d3273d1a0c9f8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d94d12a59475fe7cc9ba31e53be997c0e1d50d24099a808e6d3273d1a0c9f8e"
    sha256 cellar: :any_skip_relocation, monterey:       "8b21e00bbd5d9c432e49ab817d882f11d3eacbcc37b2920f837d1e1dd047746b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b21e00bbd5d9c432e49ab817d882f11d3eacbcc37b2920f837d1e1dd047746b"
    sha256 cellar: :any_skip_relocation, catalina:       "8b21e00bbd5d9c432e49ab817d882f11d3eacbcc37b2920f837d1e1dd047746b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d94d12a59475fe7cc9ba31e53be997c0e1d50d24099a808e6d3273d1a0c9f8e"
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
