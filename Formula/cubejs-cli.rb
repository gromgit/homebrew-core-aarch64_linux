require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.0.tgz"
  sha256 "dbc5c812a0ced4be7ec43ac6f5dc3717850b58dab9abc375bbcd9effa037ff36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "830b576f87d56124f5d06b76564e31c13428aaefa4e0ed9df58a11139bf53baa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "830b576f87d56124f5d06b76564e31c13428aaefa4e0ed9df58a11139bf53baa"
    sha256 cellar: :any_skip_relocation, monterey:       "34b4ff7a8a0fa544183f7045b42b53a85bd1cfb82594448587587ff35bf975f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b4ff7a8a0fa544183f7045b42b53a85bd1cfb82594448587587ff35bf975f2"
    sha256 cellar: :any_skip_relocation, catalina:       "34b4ff7a8a0fa544183f7045b42b53a85bd1cfb82594448587587ff35bf975f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "830b576f87d56124f5d06b76564e31c13428aaefa4e0ed9df58a11139bf53baa"
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
