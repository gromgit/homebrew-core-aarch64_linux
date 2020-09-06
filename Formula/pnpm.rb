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
    sha256 "22b75ae45eac5914e7377825f8c591ea483159d5f15627115059db6c1083ae35" => :catalina
    sha256 "a67bdab579b4643a17fe1971eb7d2c11cffb9e60755246103935cca63205747d" => :mojave
    sha256 "f41492d85a885f14c086d8b5f4afbcdb8d656337716eb4ba6864c33a88e41dbc" => :high_sierra
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
