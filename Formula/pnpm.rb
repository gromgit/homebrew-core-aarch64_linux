class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.2.tgz"
  sha256 "b07aa476fa26e7a1f5846f7de282f0a130c18f70f5256e2f28176620186020ee"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad15fcc85a703871a7cac75e68ecad9d249f612b06dbc36fbc8b651f1e7e31da" => :catalina
    sha256 "7bdbccb32dc375aef173789b13ad19ac91dd4872f3dea1eeb751a77b991877fb" => :mojave
    sha256 "c091606388bc528a363b203a25f7e7399fe0a4090d005fad3d64b5b1006ba58c" => :high_sierra
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
