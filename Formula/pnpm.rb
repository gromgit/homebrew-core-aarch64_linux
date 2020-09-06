class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.11.tgz"
  sha256 "5aeaba8bf0e642429a57ae00fc5295b9f0af520ef4a9cacd43057aba3916e679"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a351e25a0ec90d6452dc5b33aa10548f88f392ff836c27175eeaf635b080c926" => :catalina
    sha256 "f6b26de9731395ddb759fbd9fe457888e128f35960f49ee6949e965dc4becda7" => :mojave
    sha256 "749ee1a3f71450f7948aa42101c459efe6309de48060c1e4727ca092360aa0fc" => :high_sierra
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
