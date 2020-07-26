class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.4.tgz"
  sha256 "1778e5b06f5593bce7b8c3ecc99b748b853ec4ebc5fca1ea808d6edcc21403a9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d29eafa4f4ab83816f985fccd82b2185c718b249634ad313a1e5e9d698a61849" => :catalina
    sha256 "935506ce57ec43079d49d99fda9cc62540bbdead3c2bfb27e5b417a437934ff7" => :mojave
    sha256 "3dcda5561ec123cb9bbad11e82931e4e30841d2652e8d76f80c2c00fb38489e9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
