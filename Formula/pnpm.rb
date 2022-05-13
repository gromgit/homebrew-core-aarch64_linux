class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.0.tgz"
  sha256 "209fb67e60529f0be28c6dd6a82049531dfcc7c3bfec32912562fe019410fd87"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9bfce595bb7054d5192666bbc1792cb69761104be0aa3f08dc8b5c22fed4994"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9bfce595bb7054d5192666bbc1792cb69761104be0aa3f08dc8b5c22fed4994"
    sha256 cellar: :any_skip_relocation, monterey:       "b728b25b555f7beb63235d5eee95206bf1dc4dc8bb947294458750a9e96eec2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "42ba264ea38a0a9be5b81910c74e13a459f8876d3070e011ebf1e2abd4b89bca"
    sha256 cellar: :any_skip_relocation, catalina:       "42ba264ea38a0a9be5b81910c74e13a459f8876d3070e011ebf1e2abd4b89bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9bfce595bb7054d5192666bbc1792cb69761104be0aa3f08dc8b5c22fed4994"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
