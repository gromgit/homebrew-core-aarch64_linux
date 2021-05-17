class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.4.0.tgz"
  sha256 "ffc7807007aa778b8854e7968f6f7da06035230c479bc9a0c22b2144f4067afb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "084f301eee9af123990139f488d50db5d0d81694800c49780c616ca0cca8defa"
    sha256 cellar: :any_skip_relocation, big_sur:       "64029e9fe9cd616a79801a63f1cfc479f46aecaebe05a369fdda36148f093ba3"
    sha256 cellar: :any_skip_relocation, catalina:      "64029e9fe9cd616a79801a63f1cfc479f46aecaebe05a369fdda36148f093ba3"
    sha256 cellar: :any_skip_relocation, mojave:        "64029e9fe9cd616a79801a63f1cfc479f46aecaebe05a369fdda36148f093ba3"
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
