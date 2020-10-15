class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.9.3.tgz"
  sha256 "1bf71590e5408dea53ef21861d22b8e69e6da3b5b0340c340994b846328bb603"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7d8535c9986494f5503515c43b0f1d9f45a45451410c29e05d46c810899173bd" => :catalina
    sha256 "b34771c5061dda8afb50d95bde8223804df40303f4afde85cd77d566ebcbd9f4" => :mojave
    sha256 "f0c08f0cd78919a55ef2dc4987413f965fc61f70a275a9bcc5d2cb5933253e80" => :high_sierra
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
