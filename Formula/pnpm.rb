class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.10.3.tgz"
  sha256 "11311440f52a8770fa18fdc0e95d8627b06c1a0ef89f9a7f8f7a24a5a6d217d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b54a1905d3729936b6ca54ddce172ac7a00ff54381a1711e99ee7a1e28963414"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8db4c63c5d688293e9a4e39de51310e87fd76f33fb0a279e6fdeb27847e980f"
    sha256 cellar: :any_skip_relocation, catalina:      "e8db4c63c5d688293e9a4e39de51310e87fd76f33fb0a279e6fdeb27847e980f"
    sha256 cellar: :any_skip_relocation, mojave:        "e8db4c63c5d688293e9a4e39de51310e87fd76f33fb0a279e6fdeb27847e980f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b54a1905d3729936b6ca54ddce172ac7a00ff54381a1711e99ee7a1e28963414"
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
