class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.24.3.tgz"
  sha256 "d7110c57cd60d2aa795b66e110da8e11f20579b82dec8ef5a69773b49e882c16"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91c50e5232b081a0a08534c553dde96b9f5956219ea0b7da32720f86f80a298c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91c50e5232b081a0a08534c553dde96b9f5956219ea0b7da32720f86f80a298c"
    sha256 cellar: :any_skip_relocation, monterey:       "6fbf6f3bed48eb5e0444867438c0c4f3fdac967ea1d0950df7112a3f0c766f7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7c93f7c0b80a4cc70e5eef7bd7460f9f14024f1fba285e2a3107ccc70959f27"
    sha256 cellar: :any_skip_relocation, catalina:       "b7c93f7c0b80a4cc70e5eef7bd7460f9f14024f1fba285e2a3107ccc70959f27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c50e5232b081a0a08534c553dde96b9f5956219ea0b7da32720f86f80a298c"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
