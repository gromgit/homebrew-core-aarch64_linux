require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.3.tgz"
  sha256 "45108b7da5548b3dd236b1c04b9dce8bc7050cc72a3206a0787c04884de45ba4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cedbec791955e636d8f3a29a72466dd07bb1d0c44d1c45c1e09839e14d749111"
    sha256 cellar: :any_skip_relocation, big_sur:       "5efa90fe64e4b4a229fc412a4dcee95fef5b85f184b5ce0e64aefecd9369f515"
    sha256 cellar: :any_skip_relocation, catalina:      "5efa90fe64e4b4a229fc412a4dcee95fef5b85f184b5ce0e64aefecd9369f515"
    sha256 cellar: :any_skip_relocation, mojave:        "5efa90fe64e4b4a229fc412a4dcee95fef5b85f184b5ce0e64aefecd9369f515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedbec791955e636d8f3a29a72466dd07bb1d0c44d1c45c1e09839e14d749111"
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
