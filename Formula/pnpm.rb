class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.6.tgz"
  sha256 "dbf1e05432454ea4f1025cda03461c575ee394a0aa93bfa3b93f7b3f1100a380"

  bottle do
    cellar :any_skip_relocation
    sha256 "4549c75d5c5f07cdaceb59c2d6c67ba2c2889d92dde338d1f15b0faa9775d7ca" => :catalina
    sha256 "8d0c9774d3304ca2ba4b355afb85d589bd984d6f2e48100b8b416d683283d27e" => :mojave
    sha256 "70822fb9aa42e7a7843e4cc6a838ff8ba015232ca2e698ec43c0d8ba1767e84e" => :high_sierra
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
