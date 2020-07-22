class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.2.tgz"
  sha256 "e6964fd6ece41756b1ebb6c217aea729a0440efdf48d7a988fb710c69e2cad94"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b31221d99dbe6bfb27e08a3f7db37493a10f0e3337480a8acd3cd6d22196ce51" => :catalina
    sha256 "a01bb4ff493ce4efa86f2942a7474341022126074c83ec2ddfe8e9bfe267919d" => :mojave
    sha256 "03191fe83a718f17d26de2370c034f9fd256885dabf814812de813dbe688291b" => :high_sierra
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
