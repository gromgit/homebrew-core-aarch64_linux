class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.7.tgz"
  sha256 "fe7bed0a708da7b4ba8b32ce5d0dd5ee8f317997ebc92a6c06c152e9fa9a883b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b3d094d735cce1781900cab18c08ff7937b6576706bb6d02480142cde8a4eb1a" => :catalina
    sha256 "f541551855c4630e22f0656830d3ce0a09bba1f717f13bcb659b929cf3f5e407" => :mojave
    sha256 "ad5b1bf08cfaa5358d5493194efc66488a5879ba273eabfdff579948285ee2bf" => :high_sierra
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
