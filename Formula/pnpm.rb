class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.6.1.tgz"
  sha256 "a1e98062d66966be4cbf555551b2068c2b3e7dc8422e6a18527981c95fc01d56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7db4dab96cb0abc1000c55618a8e74723a40aab1bbcc4ee53560836959637599"
    sha256 cellar: :any_skip_relocation, big_sur:       "08e23560031e65fdbb434a711a4c8ff68f74a11f9c733f606de2920737815722"
    sha256 cellar: :any_skip_relocation, catalina:      "08e23560031e65fdbb434a711a4c8ff68f74a11f9c733f606de2920737815722"
    sha256 cellar: :any_skip_relocation, mojave:        "08e23560031e65fdbb434a711a4c8ff68f74a11f9c733f606de2920737815722"
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
