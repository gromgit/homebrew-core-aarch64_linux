class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.14.1.tgz"
  sha256 "4ed17ac4706ed9f7818d40cb893d0c3a8b07927f1628ef9e15ff8fb689be27b0"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dd799b43f9dd51078051f56915dd0bcc83237d5f119584bdd93395bbb31e5201" => :big_sur
    sha256 "eed9eef6ffdd632c209b5d0d82926c36ae5f901d38f406da49c81446e355ec5d" => :catalina
    sha256 "054d9fb35acc10419475cf32b7e2b44d591c549cd3aaeeb37a08df553cd42a8c" => :mojave
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
