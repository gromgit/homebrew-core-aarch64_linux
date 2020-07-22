class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.2.tgz"
  sha256 "e6964fd6ece41756b1ebb6c217aea729a0440efdf48d7a988fb710c69e2cad94"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2d235063965475855b663ed3c69c0a7cd29ce265fc1d53cb73959bcbcc9dfa7" => :catalina
    sha256 "101269da6f2476f3623c8e99f3f0216cc70475efbc4e1e0ffd7d8aa5d40d7054" => :mojave
    sha256 "b159cbe7db834bc3ea59e488147263dd5f504f3838f06bab73b3f4250704ee62" => :high_sierra
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
