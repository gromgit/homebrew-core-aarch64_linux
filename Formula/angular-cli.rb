require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.0.3.tgz"
  sha256 "75abc473ec956f1e1598937c2ecc006fde81c48cf3b7cec5fcdbdfad7ab458da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "536cd23aeb342931ca625ab138e08b3bd83eba560a8c9a7dbbea7d452346ad79"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7baa510560b1a69e7533aee1206897afaa561a60db634c56f398d122c6add6f"
    sha256 cellar: :any_skip_relocation, catalina:      "e7baa510560b1a69e7533aee1206897afaa561a60db634c56f398d122c6add6f"
    sha256 cellar: :any_skip_relocation, mojave:        "e7baa510560b1a69e7533aee1206897afaa561a60db634c56f398d122c6add6f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
