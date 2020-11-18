class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.13.1.tgz"
  sha256 "181d88a64e9ddb2e5cd2fefae3f92f5bde2d1f3f7cdcc7b659bf2d8ff1adfaba"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "db86beeb44d8df628646461c5c3548c08b5110f0464a1a419972f896f6d39568" => :big_sur
    sha256 "183b5cd7193b84704d21df6119ce679e7ee44d110ccb4d845f60634434bdf8c0" => :catalina
    sha256 "cbeed423177ed6c4207431f3e676cdfafc1d7abe89059fa5157f81fdd9f09f46" => :mojave
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
