class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.5.0.tgz"
  sha256 "ca81175d4bfcbea361308d9decc05b44bc6295e04d971202fa64c10bff718742"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16213c4dfd658cd97dd10690666864d5ee5d8cdeee3746bc710f01d582db4c31"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3c42391baa0195467faede5346ba9ff61071dcc11beef51c6ecb84c9c0b9188"
    sha256 cellar: :any_skip_relocation, catalina:      "e3c42391baa0195467faede5346ba9ff61071dcc11beef51c6ecb84c9c0b9188"
    sha256 cellar: :any_skip_relocation, mojave:        "e3c42391baa0195467faede5346ba9ff61071dcc11beef51c6ecb84c9c0b9188"
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
