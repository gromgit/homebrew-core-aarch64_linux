class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.13.tgz"
  sha256 "407c90d245f77e085fe26955501f439b89df43f8a87cb8923ebe0d3ef2e597e9"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7f3e72b383830af1c61787d989845060dc98d11293988f18ab00d0b37b907a03" => :catalina
    sha256 "1ec749066da620b4f53209d92c00113ed45d23edc5fa2eb85ee66a64fe8f4865" => :mojave
    sha256 "bbeccc310d03dec48eb3df61e3c426d7366acdd2d64ca4220d551cd52eb4059a" => :high_sierra
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
