class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.17.1.tgz"
  sha256 "6d4067c26b47069a1aa7b435ec786ad94a8098a388a4884574cb271d52d6c0d0"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b26fa8bc92adddc23223756368f838d5a2e4bae203a7cdfb1528bf9d2a8062e1"
    sha256 cellar: :any_skip_relocation, big_sur:       "100cbea7cdf4a40fa3a25d82316ef61a5b8a22892f3009038df4db3c4f63262c"
    sha256 cellar: :any_skip_relocation, catalina:      "100cbea7cdf4a40fa3a25d82316ef61a5b8a22892f3009038df4db3c4f63262c"
    sha256 cellar: :any_skip_relocation, mojave:        "100cbea7cdf4a40fa3a25d82316ef61a5b8a22892f3009038df4db3c4f63262c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b26fa8bc92adddc23223756368f838d5a2e4bae203a7cdfb1528bf9d2a8062e1"
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
