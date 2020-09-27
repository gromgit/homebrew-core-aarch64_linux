class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.8.0.tgz"
  sha256 "c1c6316f337aef60b984818bd4e99a609e43a58e574bf42e1ecc5a74cea2c572"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ae19430eb74c7aa1e55b8bedd8302ab276989414074d27d5887a41b65635446e" => :catalina
    sha256 "5688920ef34d6d6a1aa54f9b0ee94a0c34b9e8ac5ceb03bad98cafe3cba4b990" => :mojave
    sha256 "07205c30375ee176cfa893fa46118f3a0d7b069de449145ac05df5c5bdcae84d" => :high_sierra
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
