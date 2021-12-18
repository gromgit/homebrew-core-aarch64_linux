require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.5.tgz"
  sha256 "3a8a3ba1ca1af1fecd0e474bcb36792351c0e736aea68a16f64173dc3468232f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83b6d59f4c6daf99298db8afff47e58e5e89c2fa3516c4c9eb62f0b6ef122839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83b6d59f4c6daf99298db8afff47e58e5e89c2fa3516c4c9eb62f0b6ef122839"
    sha256 cellar: :any_skip_relocation, monterey:       "2946c88ad6e487a52d65901494941a8b12961744fee05656dc2b4140cf8079e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2946c88ad6e487a52d65901494941a8b12961744fee05656dc2b4140cf8079e3"
    sha256 cellar: :any_skip_relocation, catalina:       "2946c88ad6e487a52d65901494941a8b12961744fee05656dc2b4140cf8079e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b6d59f4c6daf99298db8afff47e58e5e89c2fa3516c4c9eb62f0b6ef122839"
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
