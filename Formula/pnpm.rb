class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.7.2.tgz"
  sha256 "c897d217fa85b35cb49d0d7cd734335428289c75b2f1febbc1af3337e6829751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bdd58b55f931affd90e176c8dcc57939ef94b0576934ec07a40c76d6fc60b91"
    sha256 cellar: :any_skip_relocation, big_sur:       "df998f0b916fe1cc01f992426a90b4ed2011349e223b6bd1712b87eeb8c45ccc"
    sha256 cellar: :any_skip_relocation, catalina:      "df998f0b916fe1cc01f992426a90b4ed2011349e223b6bd1712b87eeb8c45ccc"
    sha256 cellar: :any_skip_relocation, mojave:        "df998f0b916fe1cc01f992426a90b4ed2011349e223b6bd1712b87eeb8c45ccc"
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
