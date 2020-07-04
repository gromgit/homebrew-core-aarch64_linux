class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.2.8.tgz"
  sha256 "b707f32707b15e2dd49052bc4b7c87c29596ad7ed80f26f05025541a71dad4b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "649d3cba5faecaed6313c3e9f3e8c36f38ec399a56412dda7f564f544d66d641" => :catalina
    sha256 "0d38bc1d2bfdf6d61b53c82ed8773b035339200a5ee708b1a534988b6bb656aa" => :mojave
    sha256 "129436e64d944315ccad6ece6f2c6f32931cc3565e21e88f9b434bb771c452d9" => :high_sierra
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
