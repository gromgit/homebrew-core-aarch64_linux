class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.14.2.tgz"
  sha256 "f0b3436b460c40f98a1453e8b0d8e8038b15268c96ff4d35e8de437de20f28a9"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c158f963f3d57ef2cbbf6a90863f8756e796b01c6d992cd9a5b68a2f72517a56" => :big_sur
    sha256 "7f02af2ba86cf72ca1b2ececee0cbc8333b151b013cca7850677d5c6fc851a65" => :arm64_big_sur
    sha256 "d65aa2880d77c1955fc6a6beacdf1c046e4e4244003fc68531afe30f93eaacac" => :catalina
    sha256 "18b8992eeccf7d2e923ff8948e8bbf04273c32914d80fd797afa60458ac2f861" => :mojave
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
