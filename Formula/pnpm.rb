class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.4.10.tgz"
  sha256 "b36ea231b6281b5afff653abb8f90f29829b9fd8f51389bf461739c6529f5462"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b20958d26e4b7c4a4c7c6a115dec62a82f25c281d421c6bac9fdbf9797964a6" => :catalina
    sha256 "14e52ce48f4fcbd7a606fcd9cccd45fbf4280de6f9f570dfcc485d7c3fe644f2" => :mojave
    sha256 "6e9b652aa9d3a41a6a9e8974f0b002c767d21d8909dc9fe8d49b23544462d594" => :high_sierra
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
