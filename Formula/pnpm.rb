class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.6.1.tgz"
  sha256 "826df94ac0535f2fc67c5656cfc09ceb873eab7f584e12b6d8043028900549c8"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c7f593b91403281b298ed9e31b419c33388269b04b6c88c5ea46a0f39bff3059" => :catalina
    sha256 "56bfd918e6b0541356501e60efc8119f5d21a40cf4a533ddd314d90e1e14b119" => :mojave
    sha256 "d2abedc3d6a47d9cca966441b2ba35ae86f677f27c15eb23558c754449844c37" => :high_sierra
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
