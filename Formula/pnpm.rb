class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.6.tgz"
  sha256 "dbf1e05432454ea4f1025cda03461c575ee394a0aa93bfa3b93f7b3f1100a380"

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
