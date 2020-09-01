class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.5.tgz"
  sha256 "360b8bed8c7ac80743c550be2b971c8885812ed55138ed25d5e26e3cbf1c8490"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "278910dfef3103d3d7e952110c4ab6c38de25e1d901da8346966c4c496b3d1a0" => :catalina
    sha256 "5fcae9171997f25c9b42047e3f3b224960df7e86df1f24778330216ec1a7defd" => :mojave
    sha256 "f78854d195cf709b87f119517928840cee41cb2300d404bb6252c80f724d1d3a" => :high_sierra
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
