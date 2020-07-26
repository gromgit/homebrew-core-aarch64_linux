class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.4.tgz"
  sha256 "1778e5b06f5593bce7b8c3ecc99b748b853ec4ebc5fca1ea808d6edcc21403a9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "48834e7f5a94e2728182740779504bec7134098580fc092245cf8dd3a7185481" => :catalina
    sha256 "195d7495fb8ed48989e78356e47df17cc01d709a52b96f964ce2431491291f36" => :mojave
    sha256 "4a68d3b0e957a45219e56811ab6e58b73f9a6fac5b2873af57b87b3ba409cc7a" => :high_sierra
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
