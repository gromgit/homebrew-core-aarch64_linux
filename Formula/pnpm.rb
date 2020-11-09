class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.11.1.tgz"
  sha256 "daa764facff1d1e5bfc420f2c98b135a8afa6beb35699753c6d8b85970c6f9d0"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b5f680f21d7bbc3d8696262718099ffafed8fc48d57775650c0d1a82e2d23589" => :catalina
    sha256 "4410b7add86f149db5cb5d50ce9bdc392765fbd414c786b68102b91b36394da9" => :mojave
    sha256 "e1b8de8a4b1701d313e08d9c36b23fdd1d3036c0e75f7b4ed1712766328cf1c1" => :high_sierra
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
