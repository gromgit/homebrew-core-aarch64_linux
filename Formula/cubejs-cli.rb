require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.9.tgz"
  sha256 "938d83f9481290e61767c5158618f8670977a794a9485098df2a0712b4ca9056"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5c529270417453844f156743de348f20b37240a0f677bbfb36d8e887492f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb5c529270417453844f156743de348f20b37240a0f677bbfb36d8e887492f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "cc30575b85f732958e3441f5a23d2ecb892a7963e390b6950a03a637ebeb8c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc30575b85f732958e3441f5a23d2ecb892a7963e390b6950a03a637ebeb8c15"
    sha256 cellar: :any_skip_relocation, catalina:       "cc30575b85f732958e3441f5a23d2ecb892a7963e390b6950a03a637ebeb8c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb5c529270417453844f156743de348f20b37240a0f677bbfb36d8e887492f5a"
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
