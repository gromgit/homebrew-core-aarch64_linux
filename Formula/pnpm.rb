class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.4.tgz"
  sha256 "87b48d01a7ca8ca52b1af68ad02255c5f77f74f53d756e37a2d6ee4885950ee3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7cb2cc0d970e3c1cd123197cf5660e4b541d24f375f549235d88b4bc066bb23" => :catalina
    sha256 "66ec4626ae3630167355e509fc016ccb36ec76ded7588567034acb41e808c64b" => :mojave
    sha256 "b654d99e9ff84412e1704f9cc4a117038f5e4b4e598a78de6dc649541038fc0a" => :high_sierra
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
