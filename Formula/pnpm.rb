class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.0.tgz"
  sha256 "1cab18adc1286ff8261fa492afee4dd6306555df8af697df09512fdeb020adba"

  bottle do
    cellar :any_skip_relocation
    sha256 "77ec58a093b8634a72ef7828883dfc7ca3bab98802de5068de637706cbc7dd71" => :catalina
    sha256 "c2f94c9c8c06ca515e53dd7546ea5aae881df5a2d9dd781a10ce3cf618fb460c" => :mojave
    sha256 "b84c412b038af874596a36e49dbbb887e150fb32f113c768e9ab47591bbf9dac" => :high_sierra
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
