class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.18.2.tgz"
  sha256 "97ed39f35b9b8691c65882afbdff2c1cde8f63c57f71da7d360aa773e15eee9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "769d0af7485c87c155e0c54824760cf83494e6b6227e120a9566064fda82ca9c"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c7d9e03b80c50567e903761f072a6104c03e1149461608b579ad7e14d7db46e"
    sha256 cellar: :any_skip_relocation, catalina:      "9c0b251c258ad5d0f791b2318e89ff8183f553f34a570a2cab5286d22cfdac58"
    sha256 cellar: :any_skip_relocation, mojave:        "5b0d96d041cb24bce7208d3c4b96d15a673dabafa11ab1c49236b6686446e1dd"
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
