require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.62.tgz"
  sha256 "430e4a99a7fda2c5acf23a600b6aa2992e19a389a4c5031b0a0f7884388faead"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2168bfd3d1d2d273e4618efdfd31481249ad9521656a68ddda1f2cc06b334e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2168bfd3d1d2d273e4618efdfd31481249ad9521656a68ddda1f2cc06b334e7"
    sha256 cellar: :any_skip_relocation, monterey:       "d71684469264fb724d5c0f59c525f8d2af7e9a3833a3b26dd20d2624d4e0d13f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d71684469264fb724d5c0f59c525f8d2af7e9a3833a3b26dd20d2624d4e0d13f"
    sha256 cellar: :any_skip_relocation, catalina:       "d71684469264fb724d5c0f59c525f8d2af7e9a3833a3b26dd20d2624d4e0d13f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2168bfd3d1d2d273e4618efdfd31481249ad9521656a68ddda1f2cc06b334e7"
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
