class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.12.tgz"
  sha256 "89894687dfbee138a6240dd96b0d540ead5a6bffa97fa27d60d7a105f9d628fd"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b34c91c44f276cbb3f2082ded46452ac67a6a97233c5659b0082e401ca549114" => :catalina
    sha256 "8a0963352d5b74b74e2cedbc45bbdb4627a474dc456869c8311b8fe396b81ecf" => :mojave
    sha256 "447f51b513ee1670b66d38975a9c3637bf62c5d33acf7d3eaab5b75733f89a79" => :high_sierra
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
