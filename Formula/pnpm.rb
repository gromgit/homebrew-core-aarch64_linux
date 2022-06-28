class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.4.0.tgz"
  sha256 "9c70e157619e6b956d08ae3f69be00d67b191529b943cadd200254f4d1d18b98"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4eeab2f6fea4434754039ea5ec0ea645314a988ea322d4ac3f53b1961b2b02a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4eeab2f6fea4434754039ea5ec0ea645314a988ea322d4ac3f53b1961b2b02a"
    sha256 cellar: :any_skip_relocation, monterey:       "b5146eb81b7f3cc1a1623667bebdc4458f680bdc1718797ca199557562f18b83"
    sha256 cellar: :any_skip_relocation, big_sur:        "5be10b944a4b7931cd9755787159c8c5da46af604efa309e23a776e31ca13d1d"
    sha256 cellar: :any_skip_relocation, catalina:       "5be10b944a4b7931cd9755787159c8c5da46af604efa309e23a776e31ca13d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4eeab2f6fea4434754039ea5ec0ea645314a988ea322d4ac3f53b1961b2b02a"
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
