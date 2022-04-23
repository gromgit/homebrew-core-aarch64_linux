require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.51.tgz"
  sha256 "af3b99518fcb0a84eecff8bbea20831d96ad05dd61b0747ea77c779ec05e4278"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf397ae827bae9926b9a2deb5395b0da522cb41cb22914edc8c3d0faf34f9a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbf397ae827bae9926b9a2deb5395b0da522cb41cb22914edc8c3d0faf34f9a7"
    sha256 cellar: :any_skip_relocation, monterey:       "6601cddbb71c4fdb97f4e6cb40fbde31d94adc603a28eddf0d50b9cd0bccd3f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6601cddbb71c4fdb97f4e6cb40fbde31d94adc603a28eddf0d50b9cd0bccd3f7"
    sha256 cellar: :any_skip_relocation, catalina:       "6601cddbb71c4fdb97f4e6cb40fbde31d94adc603a28eddf0d50b9cd0bccd3f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbf397ae827bae9926b9a2deb5395b0da522cb41cb22914edc8c3d0faf34f9a7"
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
