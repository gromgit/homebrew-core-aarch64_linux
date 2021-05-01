class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.2.4.tgz"
  sha256 "f605a7a14d4dca4fb74a21b03d69b5d7adb627fe53bf89b045d855870741ea33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66b79b62333d32ba03d25196691c6526a6906ec97f2f75578362cbc8bb437096"
    sha256 cellar: :any_skip_relocation, big_sur:       "e288887deebdf1cd1683af2c00a50ed1931e66ab7767aba0be19f57fad738f17"
    sha256 cellar: :any_skip_relocation, catalina:      "e288887deebdf1cd1683af2c00a50ed1931e66ab7767aba0be19f57fad738f17"
    sha256 cellar: :any_skip_relocation, mojave:        "e288887deebdf1cd1683af2c00a50ed1931e66ab7767aba0be19f57fad738f17"
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
