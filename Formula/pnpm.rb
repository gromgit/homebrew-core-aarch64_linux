class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.1.0.tgz"
  sha256 "209fb67e60529f0be28c6dd6a82049531dfcc7c3bfec32912562fe019410fd87"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce278c7223b8c62eb4707abe0064132f62972ff3df87cc091cb98b55b6fdf016"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce278c7223b8c62eb4707abe0064132f62972ff3df87cc091cb98b55b6fdf016"
    sha256 cellar: :any_skip_relocation, monterey:       "154b36a51c68d779e5245fe29e366adca888edf9f069b5866a5fca2cc87ffaaa"
    sha256 cellar: :any_skip_relocation, big_sur:        "85a2f179265e03ce6acb509aa89709110c972dd6613d557f7c9e4162e4077230"
    sha256 cellar: :any_skip_relocation, catalina:       "85a2f179265e03ce6acb509aa89709110c972dd6613d557f7c9e4162e4077230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce278c7223b8c62eb4707abe0064132f62972ff3df87cc091cb98b55b6fdf016"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
