class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.13.3.tgz"
  sha256 "9dbd8e1a146ff7422f0d032fc7738ac5514e289d8da1a068f02e1449ff07100c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e8cef32d80bac599bba551d313c3e39ef1b4c42da4c14b73dcb830d1cd670661" => :big_sur
    sha256 "309d057481ba450b52489cbb247960b77acf58a8b96fc0b0d7e027254ffdff8f" => :catalina
    sha256 "3fb4e23a77b1e06a0974925fcba7705a5e1de5dc81275e1dade7b6e7b7f0cf60" => :mojave
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
