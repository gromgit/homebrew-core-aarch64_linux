class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.3.tgz"
  sha256 "88c312e45a9d171363b2858986ee26c3bc649e6c33fbf9aea3fc24c12c70b14f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c80b254fee0eae07268cf8deda0ca045a9cdfb920193e8631446c6241aa6fc09" => :catalina
    sha256 "cf88f65dc69978acab05ebb4eee7a1500d83650734f88381d04b2275e2e07036" => :mojave
    sha256 "caaf1de505b0f84a227ddce30c853d49dcb7120124bed20da5c27adb6865b765" => :high_sierra
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
