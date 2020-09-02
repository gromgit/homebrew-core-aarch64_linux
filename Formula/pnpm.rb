class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.8.tgz"
  sha256 "457062ff96568660c30c407b09e7a7f9ce5b34df13b91523f523b183574ec546"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2d48087e3cf42cdbd6238a05da9329e582b0a69bc3b77693a652c7092c059d2d" => :catalina
    sha256 "02721a3ae01a23144cd891c9acc1b4623f4b6af733de8efb30adffe3da4dfba2" => :mojave
    sha256 "0bf65c66323f44068c464dd0e1434ebdde1cd27d16936f5251ed4382446a4637" => :high_sierra
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
