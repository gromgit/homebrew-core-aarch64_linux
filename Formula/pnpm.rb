class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.6.2.tgz"
  sha256 "5d1141b1fd1c649da492e187c7f1a119440a779b0d74384f816df3e02c5e515a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94ed7f0916711c6737c1cb12798c1713f17be3e8686ed3f6a7888e1803de4050"
    sha256 cellar: :any_skip_relocation, big_sur:       "84849f7a632e492f614a4110d58ed7cb656d91d818dac81916cf7383d4d002f5"
    sha256 cellar: :any_skip_relocation, catalina:      "84849f7a632e492f614a4110d58ed7cb656d91d818dac81916cf7383d4d002f5"
    sha256 cellar: :any_skip_relocation, mojave:        "84849f7a632e492f614a4110d58ed7cb656d91d818dac81916cf7383d4d002f5"
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
