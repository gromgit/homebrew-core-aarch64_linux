class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.8.tgz"
  sha256 "457062ff96568660c30c407b09e7a7f9ce5b34df13b91523f523b183574ec546"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0ad40c30d062bb39fc4933e95f6c14a7129acd4ce9acd3fd07562ecfb1f919dc" => :catalina
    sha256 "85048e1367844b22e93e566f03eb1e68f574df00bf14655aba4e9d7c344924af" => :mojave
    sha256 "81e011a4dc73c658f5856d7140e1a8833c086445d392c8d1a88f0b04c5014bdc" => :high_sierra
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
