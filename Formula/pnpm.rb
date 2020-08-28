class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.4.tgz"
  sha256 "449182787e162b7aa5040fb303e622151f637249737d71737eb372d13cedcd63"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "94c40bc2d914ca0ffb87f197bc5f484b26d83fd9315d548ec7a537263e87d524" => :catalina
    sha256 "261b4d2f2f444cb09bef6d1109c3be8112f16b51e2d37d8ddb987fefbfa6356e" => :mojave
    sha256 "247ab7eb67f8b82a895fe3f94a8e355b2bc00057fb64c3b7f8420ab9508508b3" => :high_sierra
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
