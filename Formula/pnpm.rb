class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.18.3.tgz"
  sha256 "d14a4eedf8be5da8fe60dcd0e8849ce870b75e424c7bceccb548b63b15239fdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f75ba6ebae031fc5f574c342dd35d0e5157c465c902e5911a593d17664423193"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c96324a755b4055bf4360e45ab89c8cd08abf1d634ad7dd161e24bd453b44e9"
    sha256 cellar: :any_skip_relocation, catalina:      "20438eca91d71f008a48ef665579991e09d47506413e4d0b0b8ffd1326399311"
    sha256 cellar: :any_skip_relocation, mojave:        "c0b880fdf2e031ed3a265080b844b4ffc1f65dd3b0601eb235d563d88b6f3227"
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
