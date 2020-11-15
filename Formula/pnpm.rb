class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.12.0.tgz"
  sha256 "98d3c8b2dac310cbf472d380942b032b7d1f2560d2bf9626feac6cefc0559986"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5af4d9e336fb3e93fd66a08cbb9eaea16c3c927dfc59c08444b0b1d185362be8" => :catalina
    sha256 "1b699ecd9dbebbe1ddd3ccef70c983f773c9d0d966022b345d84fb009f08c9f1" => :mojave
    sha256 "5399489f5309345034d8c45ad57273b1328d2d9bd1859613446713ed8eb1f749" => :high_sierra
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
