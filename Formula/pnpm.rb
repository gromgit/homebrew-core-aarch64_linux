class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.9.tgz"
  sha256 "3381a893fbfdb08f53050342a4664f1fe9f9044e06236e415d32af508e2a4595"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9444dbfe9a5fd4bd6a6b0e182bf54eea4c8b340076e2ffa8dd8ee9df4f8d4149" => :catalina
    sha256 "be80eff2ce150e33218b22eee8ec8f6b7fa0a88ed0672bcfff40a7f5617b2f2d" => :mojave
    sha256 "977843cdc2050d185c0b9ccb43fc1e41331bf5b8e569127d6dee9161fd36b9ea" => :high_sierra
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
