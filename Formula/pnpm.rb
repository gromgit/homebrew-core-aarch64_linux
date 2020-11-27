class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.13.5.tgz"
  sha256 "39a19943d4494f4aa71a1eadc2f5c4f9122657639708bc625c7f284807d07fa1"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "67b32e743ef1900e24c37f940fb0f9828fa1c9e509a7b8f036dc54b252596c8b" => :big_sur
    sha256 "ded1368fc5934cd9ecb5a1137f6d4e1a4da56c4bdaaacfa04bdfc6291b4ee2b6" => :catalina
    sha256 "8e1393d61415866d0988724025430a4ad41f2cfa0c734a4d10eaa5cc69032e2c" => :mojave
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
