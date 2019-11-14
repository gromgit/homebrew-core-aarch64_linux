class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.2.2.tgz"
  sha256 "76beaff879c0d3d6a03674cbe9982120317f6e722aa48f3291c18519ca66b554"

  bottle do
    cellar :any_skip_relocation
    sha256 "571e1e3230f015761cc5a1c77f25b149caeb3f1b93b86ffc58319fd317aafc76" => :catalina
    sha256 "7f1c909d0519a727f0e9cb96121137354beb45eb11c9569ee93899a1d1e1d8d8" => :mojave
    sha256 "5ec0603fe9e166ec5781ba3e4ba3c286445f1e6d1adb3e8a5c77263e3d8733a3" => :high_sierra
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
