class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.7.tgz"
  sha256 "8efeda3cad5e9f3cd5365cc65fd53c218f8e6f0d48d32cb1433f7d36d42a817f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "76480e7d8e4f37547cec5640c41d0fd1be1403b6be548ce0a5c7c6165006447e" => :catalina
    sha256 "ac6fd9f7b53deaeae74f0f8e8a1c1ba5242ab742d61521d64599d15c0bfca8f8" => :mojave
    sha256 "7429f0f9ab6441f81b7fde8a028cb52318835e6d14f561a09adf0f9f0a71b28d" => :high_sierra
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
