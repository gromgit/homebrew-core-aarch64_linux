require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.0.4.tgz"
  sha256 "3a7cab1a5699fc88cc43c0a8cc21e2913c885c0b11eb5a11cce7eb989d81b373"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a2e53fc933df858cc56dfa665d055ebb73034c0d316e9b3c93267ec42164c28"
    sha256 cellar: :any_skip_relocation, big_sur:       "db62c6f3c5855dcee3138137b1f571a2380c7304717f980e36684bf781277635"
    sha256 cellar: :any_skip_relocation, catalina:      "db62c6f3c5855dcee3138137b1f571a2380c7304717f980e36684bf781277635"
    sha256 cellar: :any_skip_relocation, mojave:        "db62c6f3c5855dcee3138137b1f571a2380c7304717f980e36684bf781277635"
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
