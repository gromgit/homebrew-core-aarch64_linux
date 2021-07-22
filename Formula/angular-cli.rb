require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.1.3.tgz"
  sha256 "a1a41d018030c043b5f4a3dffb795071d429555db061994c80b946873c7896ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ca8f15d73f12ed1ffc4954890a7d146070052f9ff20a117b5d53968cb200ddf"
    sha256 cellar: :any_skip_relocation, big_sur:       "02b0917f66a03ca32840de73daa3651fd311dbb6d8f14f0456405d0121100e07"
    sha256 cellar: :any_skip_relocation, catalina:      "02b0917f66a03ca32840de73daa3651fd311dbb6d8f14f0456405d0121100e07"
    sha256 cellar: :any_skip_relocation, mojave:        "02b0917f66a03ca32840de73daa3651fd311dbb6d8f14f0456405d0121100e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca8f15d73f12ed1ffc4954890a7d146070052f9ff20a117b5d53968cb200ddf"
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
