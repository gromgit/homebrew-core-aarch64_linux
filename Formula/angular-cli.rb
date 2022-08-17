require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.1.3.tgz"
  sha256 "9f1aa1a7a8b56df95999bbeebd5f70c90d3094bf8b47154ac128ad4345caccaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0447a9641346a2db43d586628cc9e8ca7a173b340a5a3609ee75aa2e4fab6f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0447a9641346a2db43d586628cc9e8ca7a173b340a5a3609ee75aa2e4fab6f3"
    sha256 cellar: :any_skip_relocation, monterey:       "b61975f74a39331c78c6ba9c6dc16ac5fd7176c0c97be4b7ba5680651f0a9b92"
    sha256 cellar: :any_skip_relocation, big_sur:        "b61975f74a39331c78c6ba9c6dc16ac5fd7176c0c97be4b7ba5680651f0a9b92"
    sha256 cellar: :any_skip_relocation, catalina:       "b61975f74a39331c78c6ba9c6dc16ac5fd7176c0c97be4b7ba5680651f0a9b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0447a9641346a2db43d586628cc9e8ca7a173b340a5a3609ee75aa2e4fab6f3"
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
