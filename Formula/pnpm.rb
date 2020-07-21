class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.1.tgz"
  sha256 "ad00089e42274c6ca4d3801d830e2851db57e740790528f645bacf46043c0876"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d47d858ff02964e991d307553339e5e4451520b5172e16b6cf5cc81d696f841c" => :catalina
    sha256 "f481a3255af1bec90d5f15beb4bec98aedc0d98aca2d543806aa050f0e4e0d43" => :mojave
    sha256 "93108d90f54645ffcec4a9179f552175cf24de1105bc019a740ecf8c6f195d93" => :high_sierra
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
