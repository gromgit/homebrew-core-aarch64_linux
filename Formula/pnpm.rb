class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.10.2.tgz"
  sha256 "fbbb9a49d0f3ee4655f993c8a217982193b421c46e9e0405e0147f42af0949c9"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "23fc96700472fedf5576f402fdf56e2f5848bbd4cba9be8d7b62b0472393be2a" => :catalina
    sha256 "84e8e36d1a34f2f77e6e68ceb8c8684bb6486780472641cb7d3a8a358e506128" => :mojave
    sha256 "cb15323459eb8b9faa3c131a2d909becb1b7df8def72830b83ed8e7ad1fc7808" => :high_sierra
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
