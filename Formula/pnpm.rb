class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.2.2.tgz"
  sha256 "76beaff879c0d3d6a03674cbe9982120317f6e722aa48f3291c18519ca66b554"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dbd7cebdd744a300507db3ce4f4e7221067d349661e82df27aa1ebb872c9f88" => :catalina
    sha256 "77ec56df68a04a92fab944debe3e37c7572c9caa5d113e9b52a161a541dba64d" => :mojave
    sha256 "330f934158bf37047294a48327c75b0a4046bb4691b4f5046a969fcbe81e6eb2" => :high_sierra
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
