class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.1.tgz"
  sha256 "293fb6d110e4d6fad483a910a6c517517a389b8519af4ce5c10728de6e360403"

  bottle do
    cellar :any_skip_relocation
    sha256 "999a796a26560ad38e72a59c83d3d3d4f0afd1ec4b71a6d7ca020cf5bc9b7283" => :catalina
    sha256 "510d3aa7049540318b768799bcb0a421ab0aa974566d2e281d99a37f82c48c40" => :mojave
    sha256 "d5ac6d80981a9e291b9a845d50406438cb702419d52eee194054b6615704e0b8" => :high_sierra
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
