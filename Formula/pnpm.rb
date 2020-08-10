class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.1.tgz"
  sha256 "26d207b44af9b88ba49a7e48175b00241dce064b38219ab649f8ebfc6d670ff5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fc1c87bc890ac62ac836f22c8e83ff15c2ac2fc590b95800261c6f40241d7ad" => :catalina
    sha256 "d22f6e4780ea39a0e262161c651ef0201a3fb017642f0be5ee0cdfacfce3a5b9" => :mojave
    sha256 "dda45b63ca2b40e359b0df405d23f8abcd00faf0107a39fd3372aae99e839b76" => :high_sierra
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
