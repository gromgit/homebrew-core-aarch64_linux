class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.2.tgz"
  sha256 "caace7bc1af6a6b187f927a66694e868695afa798aaad51cdf36059adbdb4dfa"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6c70ab47dce57d05ec1d38ca3de8a9cc058059259f8191e8c5c5fc1ff9b4cef" => :catalina
    sha256 "2cd1fe79381fc1c5e25213f84fea2275e4eb48b2a66a3b7f324f71bccfac78b5" => :mojave
    sha256 "1d9226ef0c646f325453ebd6ba6941d13efb5e19d9b55f148e1dc09e481faf01" => :high_sierra
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
