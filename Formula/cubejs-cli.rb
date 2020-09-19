require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.20.9.tgz"
  sha256 "39134afbf38daab24060a26f14d8fde5bde37fe8990ca0e1767466e0eb964e2b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cd9a1c2479b45a3e9d8fdd7e93e0fcc204b4e6d7f9cc842e5196f1a27fb6f5a7" => :catalina
    sha256 "b269665c1eec47a241cbd4a2252277961e8c021627021960b2d5bf5e5facba3f" => :mojave
    sha256 "1e3798bf65ca2b5708878e77582e17761d62a35065f6a846c09c2327ec518a4a" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
