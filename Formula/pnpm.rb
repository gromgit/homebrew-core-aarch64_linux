class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.3.tgz"
  sha256 "63f10d68e05997615b288941d46ece1c36171b0e1c28287085e8047cf90a8ccd"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcb03d2716dfd41f026aa2d8aa324dcb8e57d58212fed3456efc5c9d0d22dde6" => :catalina
    sha256 "8f52b1da6e7bd980e83b7f925fbd5f97e3f43d7a74a373e27caac8ad64201308" => :mojave
    sha256 "fdc0930fb1b18d26acfad3484656641477960590e63bc33905239afcc476bbf8" => :high_sierra
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
