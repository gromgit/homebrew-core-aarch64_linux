class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.1.tgz"
  sha256 "293fb6d110e4d6fad483a910a6c517517a389b8519af4ce5c10728de6e360403"

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
