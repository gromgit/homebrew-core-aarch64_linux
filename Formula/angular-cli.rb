require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.4.tgz"
  sha256 "6cc369df89a7edcc600119b1dfb4495d2adde6269edbb7825e3e69d31befed50"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a90e85bb8b28c2ab6fecd5aa4a4b716cfa5c5e61cb23212eb1c4b232d17533f" => :catalina
    sha256 "969f1c8bda7a4f3bab052c12e8a16992213642769890dfa3a4056703d6b8db25" => :mojave
    sha256 "d5a4209a8cb75764ef3b51adf8fc90a8da7e03cd9f38650e7f76489ae6320531" => :high_sierra
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
